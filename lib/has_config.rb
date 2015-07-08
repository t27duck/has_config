require "has_config/version"

module HasConfig
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_config(key, type, default:nil, group:nil, validations:{})
      raise 'Invalid type' unless [:string, :integer, :boolean].include?(type)

      define_method(key) do
        config = (attributes[self.class.configuration_column] || {})
        config[key.to_s].nil? ? default : config[key.to_s]
      end

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

    def configuration_column
      @configuration_column ||= 'configuration'
    end

    def configuration_column=(column_name)
      @configuration_column = column_name.to_s
    end
  end

end
