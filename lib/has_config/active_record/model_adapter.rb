module HasConfig
  module ActiveRecord
    module ModelAdapter
      DEFAULT_CONFIGURATION_COLUMN = 'configuration'.freeze

      def self.included(base)
        base.extend ClassMethods
      end

      def has_config_processor
        @has_config_processor ||= HasConfig::ActiveRecord::Processor.new(self)
      end

      module ClassMethods
        def has_config(key, parent: nil, config: {})
          configuration = HasConfig::Engine.known_configurations[key.to_sym]
          if config.present?
            configuration = if configuration.nil?
                        HasConfig::Configuration.new(key.to_sym, config)
                      else
                        HasConfig::Configuration.modify(configuration, config)
                      end
          end
          raise HasConfig::UnknownConfig, "Unknown config #{key}" if configuration.nil?

          define_has_config_getter(configuration, parent: parent)
          define_has_config_setter(configuration)
          apply_has_config_validations(configuration)
        end

        def has_config_configuration_column
          @has_config_configuration_column ||= DEFAULT_CONFIGURATION_COLUMN
        end

        def has_config_configuration_column=(column_name)
          @has_config_configuration_column = column_name.to_s
        end

        private ################################################################

        def define_has_config_getter(configuration, parent: nil)
          define_method(configuration.name) do |mode = :none|
            has_config_processor.fetch(configuration, parent: parent, mode: mode)
          end

          if configuration.type == :boolean
            define_method("#{configuration.name}?") do |mode = :none|
              public_send(configuration.name, mode)
            end
          end
        end

        def define_has_config_setter(configuration)
          define_method("#{configuration.name}=") do |value|
            has_config_processor.set(configuration, value)
            value
          end
        end

        def apply_has_config_validations(configuration)
          [configuration.validations].flatten.each do |validation|
            validates configuration.name, validation
          end
        end
      end
    end
  end
end
