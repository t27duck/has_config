begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
end
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'has_config'

require 'minitest/autorun'
require 'minitest/pride'

require 'active_record'
require 'pg'

db_config = { adapter: 'postgresql', database: 'has_config_test' }
db_config[:username] = ENV['POSTGRES_USER'] if ENV.key?('POSTGRES_USER')
db_config[:password] = ENV['POSTGRES_PASSOWRD'] if ENV.key?('POSTGRES_PASSWORD')
db_config[:host] = ENV['POSTGRES_HOST'] if ENV.key?('POSTGRES_HOST')

ActiveRecord::Base.establish_connection(**db_config)
