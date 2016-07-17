require 'bundler/gem_tasks'

task default: :test

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'test'
  # t.pattern = "test/**/*_test.rb"
  t.pattern = 'test/test*.rb'
end

desc 'Run a console with the environment loaded'
task :console do
  require 'has_config'

  require 'active_record'
  require 'pg'
  require 'irb'
  require 'irb/completion'
  ARGV.clear
  IRB.start
end
