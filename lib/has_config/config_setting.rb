module HasConfig
  class ConfigSetting
    CHAINING_OPTIONS  = %i(blank nil false).freeze
    VALID_TYPES       = %i(string integer boolean).freeze

    attr_reader :chain_on, :default, :name, :type, :validations

    def initialize(name, type, default: nil, validations: [], chain_on: :blank)
      @chain_on     = chain_on.to_sym
      @default      = default
      @name         = name.to_sym
      @type         = type.to_sym
      @validations  = [validations].flatten
      validate_setting
      validate_chain_on
    end

    private ####################################################################

    def validate_setting
      raise InvalidType, "Invalid type #{type}" unless VALID_TYPES.include?(type)
    end

    def validate_chain_on
      raise InvalidChainOption, "Invalid chainning option: #{chain_on}" unless CHAINING_OPTIONS.include?(chain_on)
    end
  end
end
