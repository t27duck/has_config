module HasConfig
  CHAINING_OPTIONS = %i(blank nil false)

  module ActiveRecordModel
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def has_config(key, parent: nil, chain_on: :blank)
        setting = HasConfig::Engine.settings[key.to_sym]
        raise HasConfig::UnknownConfig, "No setting found for #{key}" if setting.nil?
        raise ArgumentError, "Invalid chain_on option: #{chain_on}" unless CHAINING_OPTIONS.include?(chain_on)

        define_config_getter(setting, parent: parent, chain_on: chain_on)
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

      def define_config_getter(setting, parent: nil, chain_on: nil)
        name            = setting.name
        default         = setting.default
        include_boolean = setting.type == :boolean

        define_method(name) do
          config = (attributes[self.class.config_column] || {})
          config[name.to_s].nil? ? default : config[name.to_s]
        end

        define_method("#{name}_resolved") do
          local_value = public_send(name)
          if parent && inoke_chain?(local_value, chain_on)
            public_send(parent).public_send("#{name}_resolved")
          end
          return local_value
        end

        if include_boolean
          define_method("#{name}?") do
            config = (attributes[self.class.config_column] || {})
            config[name.to_s].nil? ? default : config[name.to_s]
          end
        end
      end

      def invoke_chain?(value, chain_on)
        case chain_on
        when :blank
          value.blank?
        when :nil
          value.nil?
        when :false
          value == false
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
