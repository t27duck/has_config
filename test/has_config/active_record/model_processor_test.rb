require 'test_helper'

class HasConfig::ActiveRecord::ProcessorTest < Minitest::Test
  HasConfig::Engine.load(path: File.expand_path("../../../config/has_config.rb", __FILE__))
  require 'schema'
  require 'models'

  def test_chaining_on_parent_that_does_not_exist_raises_an_error
    configuration = HasConfig::Configuration.new(:bad_chain, type: :string)
    model = BasicModel.new
    processor = HasConfig::ActiveRecord::Processor.new(model)
    assert_raises HasConfig::InvalidChain do
      processor.fetch(configuration, parent: :not_a_parent, mode: :resolve)
    end
  end

  def test_chaining_on_parent_that_does_not_respond_to_configuration_name_raises_an_error
    configuration = HasConfig::Configuration.new(:bad_chain, type: :string)
    model = BasicModel.new
    assert model.respond_to?(:bad_parent_method), 'Basic model does not respond to bad_parent_method'
    processor = HasConfig::ActiveRecord::Processor.new(model)
    assert_raises HasConfig::InvalidChain do
      processor.fetch(configuration, parent: :bad_parent_method, mode: :resolve)
    end
  end
end
