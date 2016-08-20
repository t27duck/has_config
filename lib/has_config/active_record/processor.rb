module HasConfig
  module ActiveRecord
    class Processor
      def initialize(model)
        @model = model
      end

      def fetch(configuration, parent: nil, mode: :none)
        local = local_value(has_config_column_data, configuration)

        if parent && mode == :resolve && HasConfig::Chain.invoke?(local, configuration.chain_on)
          check_chain(configuration, parent)
          parent_value = @model.public_send(parent).public_send(configuration.name, :resolve)
          return parent_value unless parent_value.blank?
        end

        local
      end

      def set(configuration, value)
        data          = has_config_column_data
        parsed_value  = HasConfig::ValueParser.parse(value, configuration.type)

        if data[configuration.name] != parsed_value
          data[configuration.name] = parsed_value
          @model.send(:write_attribute, has_config_column, data)
          @model.public_send("#{has_config_column}_will_change!")
        end
      end

      private ##################################################################

      def has_config_column
        @model.class.has_config_configuration_column
      end

      def has_config_column_data
        @model.attributes[has_config_column] || {}
      end

      def local_value(data, configuration)
        if data[configuration.name].nil?
          configuration.default
        else
          data[configuration.name]
        end
      end

      def check_chain(configuration, parent)
        unless @model.respond_to?(parent)
          raise HasConfig::InvalidChain, "#{parent} is not available on this model"
        end

        unless @model.public_send(parent).respond_to?(configuration.name)
          raise HasConfig::InvalidChain, "#{configuration.name} not available on #{parent}"
        end
      end
    end
  end
end
