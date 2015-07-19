class CustomColumnModel < ActiveRecord::Base
  serialize :prefs
  include HasConfig
  self.configuration_column = :prefs

  has_config :favorite_color, :string
  has_config :enable_email, :boolean
  has_config :rate_limit, :integer
end

class GroupModel < ActiveRecord::Base
  serialize :configuration
  include HasConfig

  has_config :favorite_color, :string
  has_config :enable_email, :boolean, group: :security
  has_config :rate_limit, :integer, group: :security
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

class WithDefault < ActiveRecord::Base
  serialize :configuration
  include HasConfig

  has_config :favorite_color, :string, default: 'red'
  has_config :enable_email, :boolean
  has_config :rate_limit, :integer
end

class WithGroup < ActiveRecord::Base
  serialize :configuration
  include HasConfig

  has_config :favorite_color, :string
  has_config :enable_email, :boolean, group: :some_group
  has_config :rate_limit, :integer, group: :some_group
end


class WithValidation < ActiveRecord::Base
  serialize :configuration
  include HasConfig

  has_config :favorite_color, :string, validations: {presence: true}
  has_config :enable_email, :boolean
  has_config :rate_limit, :integer, validations: {inclusion: {in: [1,2,3]}}
end
