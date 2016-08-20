require 'test_helper'

class HasConfig::ConfigurationTest < Minitest::Test
  def setup
    @name     = 'some_name'
    @type     = HasConfig::Configuration::VALID_TYPES.first
    @chain_on = HasConfig::Configuration::CHAINING_OPTIONS.first
    @default  = 1
  end

  def test_configuration_requires_type
    assert_raises HasConfig::InvalidType do
      HasConfig::Configuration.new(@name)
    end
  end

  def test_configuration_only_needs_name_and_type_and_sets_defaults
    configuration = HasConfig::Configuration.new(@name, type: @type)
    assert_equal @name, configuration.name
    assert_equal @type.to_sym, configuration.type
    assert_equal :blank, configuration.chain_on
    assert_equal nil, configuration.default
    assert_equal [], configuration.validations
  end

  def test_requires_valid_type
    assert_raises HasConfig::InvalidType do
      HasConfig::Configuration.new(@name, type: 'invalid_type')
    end

    HasConfig::Configuration::VALID_TYPES.each do |type|
      configuration = HasConfig::Configuration.new(@name, type: type)
      assert_equal type, configuration.type
    end
  end

  def test_chain_on_must_be_valid
    assert_raises HasConfig::InvalidChainOption do
      HasConfig::Configuration.new(@name, type: @type, chain_on: :bad_chain_on)
    end

    HasConfig::Configuration::CHAINING_OPTIONS.each do |chain_on|
      configuration = HasConfig::Configuration.new(@name, type: @type, chain_on: chain_on)
      assert_equal chain_on, configuration.chain_on
    end
  end

  def test_sets_default_value
    configuration = HasConfig::Configuration.new(@name, type: @type, default: @default)
    assert_equal @default, configuration.default
  end

  def test_sets_validations_to_array
    validation = { presence: true }
    configuration = HasConfig::Configuration.new(@name, type: @type, validations: validation)
    assert configuration.validations.is_a?(Array)
    assert_equal [validation], configuration.validations

    configuration = HasConfig::Configuration.new(@name, type: @type, validations: [validation])
    assert configuration.validations.is_a?(Array)
    assert_equal [validation], configuration.validations
  end
end
