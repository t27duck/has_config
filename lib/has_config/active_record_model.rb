module HasConfig
  module ActiveRecordModel
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_config(key, parent: nil)
        setting = HasConfig::Engine.settings[key.to_sym]
        raise HasConfig::UnknownConfig, "No setting found for #{key}" if setting.nil?

        define_has_config_getter(setting, parent: parent)
        define_has_config_setter(setting)
        apply_has_config_validations(setting)
      end

      def config_column
        @config_column ||= 'configuration'
      end

      def config_column=(column_name)
        @config_column = column_name.to_s
      end

      private ##################################################################

      def define_has_config_getter(setting, parent: nil)
        name = setting.name.to_s

        define_method(name) do |mode = :none|
          config      = (attributes[self.class.config_column] || {})
          local_value = config[name].nil? ? setting.default : config[name]
          return local_value unless mode == :resolve

          if parent && mode == :resolve && HasConfig::ValueParser.invoke_chain?(local_value, setting.chain_on)
            parent_value = public_send(parent).public_send(name, :resolve)
            return parent_value unless parent_value.blank?
          end

          local_value
        end

        if setting.type == :boolean
          define_method("#{name}?") do |mode = :none|
            public_send(name, mode)
          end
        end
      end

      def define_has_config_setter(setting)
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

      def apply_has_config_validations(setting)
        setting.validations.each do |validation|
          validates setting.name, validation
        end
      end
    end
  end
end
