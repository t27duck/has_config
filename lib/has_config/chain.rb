module HasConfig
  class Chain
    def self.invoke?(value, chain_on)
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
