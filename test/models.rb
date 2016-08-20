class BasicModel < ActiveRecord::Base
  serialize :configuration
  include HasConfig::ActiveRecord::ModelAdapter

  has_config :string_setting
  has_config :boolean_setting
  has_config :integer_setting

  def bad_parent_method
    nil
  end
end

class ManualSettingModel < ActiveRecord::Base
  self.table_name = 'basic_models'
  serialize :configuration
  include HasConfig::ActiveRecord::ModelAdapter

  has_config :string_setting, config: { default: 'custom' }
  has_config :manual_setting, config: { type: :string, default: 'manual' }
end

class WithValidationModel < ActiveRecord::Base
  self.table_name = 'basic_models'
  serialize :configuration
  include HasConfig::ActiveRecord::ModelAdapter

  has_config :string_setting, config: { type: :string, validations: { presence: true } }
end

class CustomColumnModel < ActiveRecord::Base
  serialize :prefs
  include HasConfig::ActiveRecord::ModelAdapter
  self.has_config_configuration_column = :prefs

  has_config :string_setting
  has_config :boolean_setting
  has_config :integer_setting
end

class JsonColumnModel < ActiveRecord::Base
  include HasConfig::ActiveRecord::ModelAdapter

  has_config :string_setting
  has_config :boolean_setting
  has_config :integer_setting
end

class JsonbColumnModel < ActiveRecord::Base
  include HasConfig::ActiveRecord::ModelAdapter

  has_config :string_setting
  has_config :boolean_setting
  has_config :integer_setting
end

class Client < ActiveRecord::Base
  has_many :groups
  include HasConfig::ActiveRecord::ModelAdapter
  has_config :chained_integer
end

class Group < ActiveRecord::Base
  belongs_to :client
  has_many :users
  include HasConfig::ActiveRecord::ModelAdapter
  has_config :chained_integer, parent: :client
end

class User < ActiveRecord::Base
  belongs_to :group
  include HasConfig::ActiveRecord::ModelAdapter
  has_config :chained_integer, parent: :group
end

class ParentModel < ActiveRecord::Base
  serialize :configuration
  include HasConfig::ActiveRecord::ModelAdapter

  has_config :string_setting
  has_config :boolean_setting
  has_config :integer_setting
end

class ChildModel < ParentModel
end
