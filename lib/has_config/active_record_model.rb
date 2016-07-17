module HasConfig
  module ActiveRecordModel
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_config(key)
        setting = HasConfig::Engine.settings[key.to_sym]
        raise HasConfig::UnknownConfig, "No setting found for #{key}" if setting.nil?

        define_config_getter(setting)
        define_config_setter(setting)
        set_config_validations(setting)
      end

      def config_column
        @config_column ||= 'configuration'
      end

      def config_column=(column_name)
        @config_column = column_name.to_s
      end

      private ##################################################################

      def define_config_getter(setting)
        name            = setting.name
        default         = setting.default
        include_boolean = setting.type == :boolean

        define_method(name) do
          config = (attributes[self.class.config_column] || {})
          config[name.to_s].nil? ? default : config[name.to_s]
        end

        if include_boolean
          define_method("#{name}?") do
            config = (attributes[self.class.config_column] || {})
            config[name.to_s].nil? ? default : config[name.to_s]
          end
        end
      end

      def define_config_setter(setting)
        name = setting.name

        define_method("#{name}=") do |input|
          config          = (attributes[self.class.config_column] || {})
          original_value  = config[name.to_s]
          parsed_value    = nil

          unless input.nil?
            parsed_value = case setting.type
                           when :string
                             input.to_s
                           when :integer
                             input.present? ? input.to_i : nil
                           when :boolean
                             ([true, 1].include?(input) || input =~ /(true|t|yes|y|1)$/i) ? true : false
            end
          end

          if original_value != parsed_value
            config[name.to_s] = parsed_value
            write_attribute(self.class.config_column, config)
            public_send("#{self.class.config_column}_will_change!")
          end

          input
        end
      end

      def set_config_validations(setting)
        return if setting.validations.blank?
        validates setting.name, setting.validations
      end
    end
  end
end
