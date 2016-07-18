module HasConfig
  module ActiveRecordModel
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_config(key, parent: nil)
        setting = HasConfig::Engine.settings[key.to_sym]
        raise HasConfig::UnknownConfig, "No setting found for #{key}" if setting.nil?

        define_config_getter(setting)
        define_config_resolved(setting.name, parent: parent, chain_on: setting.chain_on) if parent
        define_config_setter(setting)
        add_config_validations(setting)
      end

      def config_column
        @config_column ||= 'configuration'
      end

      def config_column=(column_name)
        @config_column = column_name.to_s
      end

      private ##################################################################

      def define_config_getter(setting)
        name            = setting.name.to_s
        default         = setting.default
        include_boolean = setting.type == :boolean

        define_method(name) do
          config = (attributes[self.class.config_column] || {})
          config[name].nil? ? default : config[name]
        end

        if include_boolean
          define_method("#{name}?") do
            config = (attributes[self.class.config_column] || {})
            config[name].nil? ? default : config[name]
          end
        end
      end

      def define_config_resolved(name, parent: nil, chain_on: nil)
        define_method("#{name}_resolved") do
          local_value = public_send(name)
          if parent && HasConfig::ValueParser.inoke_chain?(local_value, chain_on)
            parent_object = public_send(parent)
            if parent_object.presond_to?("#{name}_resolved".to_sym)
              parent_object.public_send("#{name}_resolved")
            else
              parent_object.public_send(name.to_sym)
            end
          end
          local_value
        end
      end

      def define_config_setter(setting)
        name = setting.name.to_s

        define_method("#{name}=") do |input|
          config          = (attributes[self.class.config_column] || {})
          parsed_value    = HasConfig::ValueParser.parse(input, setting.type)

          if config[name] != parsed_value
            config[name] = parsed_value
            write_attribute(self.class.config_column, config)
            public_send("#{self.class.config_column}_will_change!")
          end

          input
        end
      end

      def add_config_validations(setting)
        setting.validations.each do |validation|
          validates setting.name, validation
        end
      end
    end
  end
end
