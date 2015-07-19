require 'minitest_helper'

class TestHasConfig < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::HasConfig::VERSION
  end

  def test_validations_can_be_attached
    object = WithValidation.new
    refute object.valid?

    assert object.errors[:favorite_color].include?("can't be blank")
    assert object.errors[:rate_limit].include?('is not included in the list')

    object.favorite_color = 'red'
    object.rate_limit = 1
    assert object.valid?
  end

  def test_default_values_are_set
    object = WithDefault.new
    refute object.favorite_color.nil?
  end

  def test_group_organizes_config
    run_tests WithGroup

    object = WithGroup.new
    group_info = object.configuration_for_group(:some_group)
    refute group_info.has_key?(:favorite_color)
    assert group_info.has_key?(:enable_email)
    assert group_info.has_key?(:rate_limit)

    assert_equal object.configuration_for_group(:non_existant_group), {}
  end

  def test_standard_hash_column_model
    run_tests HashModel
  end

  def test_model_with_json
    run_tests JsonModel
  end

  def test_model_with_custom_config_column_functions
    run_tests CustomColumnModel
  end

  def run_tests(klass)

    default_config = {
      favorite_color: 'red',
      enable_email: true,
      rate_limit: 3
    }
    object = klass.new

    assert object.valid?

    default_config.keys.each do |config_key|
      assert object.respond_to?(config_key), "Instance of #{klass} does not respond to #{config_key}"
      assert object.respond_to?("#{config_key}="), "Instance of #{klass} does not respond to #{config_key}="
    end

    assert object.respond_to?('enable_email?'), "Instance of #{klass} does not respond to enable_email?"

    default_config.each do |key, value|
      object.public_send("#{key}=", value)
      assert_equal value, object.public_send(key), "#{key} was not set to #{value}"
    end

    ['t', 'true', '1', 1, true].each do |truth_value|
      object.enable_email = truth_value
      assert_equal true, object.enable_email, 'Bool handling did not result in true'
      assert_equal true, object.enable_email?, 'Bool handling did not result in true'
    end

    ['f', 'false', '0', 0, false, 'a string', 7].each do |false_value|
      object.enable_email = false_value
      assert_equal false, object.enable_email, 'Bool handling did not result in false'
      assert_equal false, object.enable_email?, 'Bool handling did not result in false'
    end

    object.favorite_color = nil
    assert_equal nil, object.favorite_color, 'nil passed into a string field did not result to nil'

    object.rate_limit = nil
    assert_equal nil, object.rate_limit, 'nil passed into a integer field did not result to nil'

    object.enable_email = nil
    assert_equal nil, object.enable_email, 'nil passed into a bool field did not result to nil'

    object.rate_limit = '234'
    assert_equal 234, object.rate_limit, 'String passed into an integer field did not result to an integer'

    object.rate_limit = ''
    assert_equal nil, object.rate_limit, 'Empty string passed into an integer field did not result to a nil'
  end
end
