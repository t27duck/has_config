module HasConfig
  class Configuration
    CHAINING_OPTIONS  = %i(blank nil false).freeze
    MODIFIABLE_ATTRS  = %i(chain_on default validations).freeze
    VALID_TYPES       = %i(string integer boolean).freeze

    attr_reader :name, :type
    attr_accessor(*MODIFIABLE_ATTRS)

    def self.modify(configuration, config)
      configuration = configuration.dup
      MODIFIABLE_ATTRS.each do |key|
        configuration.public_send("#{key}=", config[key]) if config.key?(key)
      end
      configuration.validate
      configuration
    end

    def initialize(name, type: nil, default: nil, validations: [], chain_on: :blank)
      raise InvalidType, 'Type is required' if type.nil?

      @chain_on     = chain_on.to_sym
      @default      = default
      @name         = name.to_s
      @type         = type.to_sym
      @validations  = [validations].flatten
      validate
    end

    def validate
      validate_configuration
      validate_chain_on
    end

    private ####################################################################

    def validate_configuration
      raise InvalidType, "Invalid type #{type}" unless VALID_TYPES.include?(type)
    end

    def validate_chain_on
      raise InvalidChainOption, "Invalid chainning option: #{chain_on}" unless CHAINING_OPTIONS.include?(chain_on)
    end
  end
end
