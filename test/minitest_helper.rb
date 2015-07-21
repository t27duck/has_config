$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'has_config'

require 'minitest/autorun'
require 'minitest/pride'

if !defined?(MiniTest::Test)
  MiniTest::Test = MiniTest::Unit::TestCase
end

require 'active_record'
require 'pg'

ActiveRecord::Base.establish_connection({
  adapter: "postgresql",
  database: "has_config_test"
})

require 'schema'
require 'models'


