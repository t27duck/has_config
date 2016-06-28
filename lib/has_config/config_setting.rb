module HasConfig
  class ConfigSetting
    VALID_TYPES = %i(string integer boolean).freeze

    attr_reader :name, :type, :default, :validations

    def initialize(name, type, default: nil, validations: {})
      @name         = name.to_sym
      @type         = type.to_sym
      @default      = default
      @validations  = validations
      validate_setting
    end

    private ####################################################################

    def validate_setting
      raise InvalidType, "Invalid type #{type}" unless VALID_TYPES.include?(type)
    end
  end
end
