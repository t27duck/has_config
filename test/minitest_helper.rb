$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'has_config'

require 'minitest/autorun'
require 'minitest/pride'

require 'active_record'
require 'pg'

ActiveRecord::Base.establish_connection({
  adapter: "postgresql",
  database: "has_config_test"
})

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :clients, :force => true do |t|
    t.string :name
    t.json :configuration
  end

end

class Client < ActiveRecord::Base
  include HasConfig
  has_config :foo, :string
end
