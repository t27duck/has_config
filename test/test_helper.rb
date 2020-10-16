begin
  require 'simplecov'
  SimpleCov.start
rescue
end
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'has_config'

require 'minitest/autorun'
require 'minitest/pride'

require 'active_record'
require 'pg'

ActiveRecord::Base.establish_connection(adapter: 'postgresql', database: 'has_config_test')
