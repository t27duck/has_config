$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'has_config'

require 'minitest/autorun'
require 'minitest/pride'

# Compatability for older MiniTest versions (ie Rails 4.0 uses MiniTest 4.7)
MiniTest::Test = MiniTest::Unit::TestCase unless defined?(MiniTest::Test)

require 'active_record'
require 'pg'

ActiveRecord::Base.establish_connection(adapter: 'postgresql',
                                        database: 'has_config_test')

HasConfig::Engine.load(path: 'test/config/settings.rb')

require 'schema'
require 'models'
