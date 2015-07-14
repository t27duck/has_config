class CustomColumnModel < ActiveRecord::Base
  serialize :prefs
  include HasConfig
  self.configuration_column = :prefs

  has_config :favorite_color, :string
  has_config :enable_email, :boolean
  has_config :rate_limit, :integer
end

class HashModel < ActiveRecord::Base
  serialize :configuration
  include HasConfig

  has_config :favorite_color, :string
  has_config :enable_email, :boolean
  has_config :rate_limit, :integer
end

class JsonModel < ActiveRecord::Base
  include HasConfig

  has_config :favorite_color, :string
  has_config :enable_email, :boolean
  has_config :rate_limit, :integer
end

