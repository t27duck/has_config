require "has_config/version"

module HasConfig
  def self.included(base)
    base.extend ClassMethods
  end

  def configuration_for_group(group_name)
    group_config = {}
    self.class.configuration_groups[group_name.to_s].each do |config_name|
      group_config[config_name.to_sym] = public_send(config_name)
    end
    group_config
  end

  module ClassMethods
    def has_config(key, type, default:nil, group:nil, validations:{})
      raise ArgumentError, "Invalid type #{type}" unless [:string, :integer, :boolean].include?(type)

      define_configuration_getter(key, default, type == :boolean)
      define_configuration_setting(key, type)
      set_configuration_group(key, group) if group.present?
      set_configuration_validations(key, validations) if validations.present?
    end

    def configuration_groups
      @configuration_groups ||= {}
    end

    def configuration_column
      @configuration_column ||= 'configuration'
    end

    def configuration_column=(column_name)
      @configuration_column = column_name.to_s
    end

    private ####################################################################

    def define_configuration_getter(key, default, include_boolean=false)
      define_method(key) do
        config = (attributes[self.class.configuration_column] || {})
        config[key.to_s].nil? ? default : config[key.to_s]
      end

      if include_boolean
        define_method("#{key}?") do
          config = (attributes[self.class.configuration_column] || {})
          config[key.to_s].nil? ? default : config[key.to_s]
        end
      end
    end

    def define_configuration_setting(key, type)
      define_method("#{key}=") do |input|
        config = (attributes[self.class.configuration_column] || {})
        if input.nil?
          config[key.to_s] = nil
        else
          case type
          when :string
            config[key.to_s] = input.to_s
          when :integer
            config[key.to_s] = input.present? ? input.to_i : nil
          when :boolean
            config[key.to_s] = ([true,1].include?(input) || input =~ (/(true|t|yes|y|1)$/i)) ? true : false
          end
        end
        write_attribute(self.class.configuration_column, config)
      end
    end

    def set_configuration_group(key, group)
      @configuration_groups ||= {}
      @configuration_groups[group.to_s] ||= []
      @configuration_groups[group.to_s] << key.to_s
    end

    def set_configuration_validations(key, validation_config)
      validates key, validation_config
    end

  end

end
