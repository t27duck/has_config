module HasConfig
  ConfigurationFileNotFound = Class.new(StandardError)
  InvalidChainOption        = Class.new(StandardError)
  InvalidChain              = Class.new(StandardError)
  InvalidType               = Class.new(StandardError)
  UnknownConfig             = Class.new(StandardError)
end
