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
        /\A(true|t|yes|y|1)\z/i === value.to_s
      end
    end
  end
end
