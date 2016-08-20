require 'test_helper'
require 'ostruct'
require 'tempfile'

class HasConfig::EngineTest < Minitest::Test
  def setup
    HasConfig::Engine.clear_configurations
    @configuration_name = :configuration_name
    @mock_configuration = OpenStruct.new(name: @configuration_name)
  end

  def teardown
    HasConfig::Engine.clear_configurations
  end

  def test_engine_holds_list_of_known_configurations
    assert HasConfig::Engine.known_configurations.is_a?(Hash)
  end

  def test_engine_registers_a_configuration
    HasConfig::Engine.register_configuration(@mock_configuration)
    refute HasConfig::Engine.known_configurations[@configuration_name].nil?
    assert_equal @mock_configuration, HasConfig::Engine.known_configurations[@configuration_name]
  end

  def test_engine_can_clear_known_configurations
    HasConfig::Engine.register_configuration(@mock_configuration)
    HasConfig::Engine.clear_configurations
    assert_equal Hash.new, HasConfig::Engine.known_configurations
  end

  def test_load_reads_a_file_and_stores_configurations
    file = Tempfile.new(['has_config_configurations', '.rb'])
    File.open(file.path, 'w') do |f|
      f.write("has_config :#{@configuration_name}_1, config: { type: :string }\n")
      f.write("has_config :#{@configuration_name}_2, config: { type: :string }\n")
    end
    HasConfig::Engine.load(path: file.path)
    assert_equal 2, HasConfig::Engine.known_configurations.size
    refute HasConfig::Engine.known_configurations["#{@configuration_name}_1".to_sym].nil?
    refute HasConfig::Engine.known_configurations["#{@configuration_name}_2".to_sym].nil?
  ensure
    if file.respond_to?(:close)
      file.close
      file.unlink
    end
  end

  def test_loads_if_file_is_not_found
    assert_raises HasConfig::ConfigurationFileNotFound do
      HasConfig::Engine.load(path: 'non-existant-path.rb')
    end
    assert_equal 0, HasConfig::Engine.known_configurations.size
  end
end
