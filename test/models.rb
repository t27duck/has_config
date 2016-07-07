class CustomColumnModel < ActiveRecord::Base
  serialize :prefs
  include HasConfig::ActiveRecordModel
  self.config_column = :prefs

  has_config :favorite_color
  has_config :enable_email
  has_config :rate_limit
end

class HashModel < ActiveRecord::Base
  serialize :configuration
  include HasConfig::ActiveRecordModel

  has_config :favorite_color
  has_config :enable_email
  has_config :rate_limit
end

class JsonModel < ActiveRecord::Base
  include HasConfig::ActiveRecordModel

  has_config :favorite_color
  has_config :enable_email
  has_config :rate_limit
end

class WithDefault < ActiveRecord::Base
  serialize :configuration
  include HasConfig::ActiveRecordModel

  has_config :favorite_color
  has_config :enable_email
  has_config :rate_limit

  has_config :favorite_color_default
end

class WithValidation < ActiveRecord::Base
  serialize :configuration
  include HasConfig::ActiveRecordModel

  has_config :favorite_color
  has_config :enable_email
  has_config :rate_limit

  has_config :listed_rate_limit
  has_config :required_favorite_color
end
