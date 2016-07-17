module HasConfig
  class ValueParser
    def self.parse(value, type)
      return nil if value.nil?
      case type
      when :string
        value.to_s
      when :integer
        value.present? ? value.to_i : nil
      when :boolean
        [true, 1].include?(value) || /\A(true|t|yes|y|1)\z/i === value
      end
    end

    def self.invoke_chain?(value, chain_on)
      case chain_on
      when :blank
        value.blank?
      when :nil
        value.nil?
      when :false
        value == false
      end
    end
  end
end
