module HasConfig
  ConfigurationNotFound = Class.new(StandardError)
  InvalidChainOption    = Class.new(StandardError)
  InvalidType           = Class.new(StandardError)
  UnknownConfig         = Class.new(StandardError)
end
