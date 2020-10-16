require 'test_helper'

class HasConfig::ActiveRecord::ModelAdapterTest < Minitest::Test
  HasConfig::Engine.load(path: File.expand_path("../../../config/has_config.rb", __FILE__))
  require 'schema'
  require 'models'

  def test_model_uses_configuration_column
    assert_equal HasConfig::ActiveRecord::ModelAdapter::DEFAULT_CONFIGURATION_COLUMN, BasicModel.has_config_configuration_column
    assert_equal 'prefs', CustomColumnModel.has_config_configuration_column
    assert_equal HasConfig::ActiveRecord::ModelAdapter::DEFAULT_CONFIGURATION_COLUMN, JsonColumnModel.has_config_configuration_column
  end

  def test_chaining_models_use_their_local_values
    client  = Client.create!(chained_integer: 3)
    group   = Group.create!(chained_integer: 2, client: client)
    user    = User.create!(chained_integer: 1, group: group)
    assert_equal 3, client.chained_integer
    assert_equal 2, group.chained_integer
    assert_equal 1, user.chained_integer
  end

  def test_chaining_models_chain_up_if_blank_and_told_to
    client  = Client.create!(chained_integer: 3)
    group   = Group.create!(chained_integer: nil, client: client)
    user    = User.create!(chained_integer: '', group: group)
    assert_equal 3, client.chained_integer(:resolve)
    assert_equal 3, client.chained_integer

    assert_nil group.chained_integer
    assert_equal 3, group.chained_integer(:resolve)
    assert_equal 3, user.chained_integer(:resolve)

    user.update!(chained_integer: 1)
    assert_equal 1, user.chained_integer
    assert_equal 1, user.chained_integer(:resolve)
  end

  def test_model_with_manually_configured_setting_works_like_normal
    model = ManualSettingModel.new
    assert_equal 'manual', model.manual_setting
    model.manual_setting = 'foo'
    assert_equal 'foo', model.manual_setting
    model.save!
    assert_equal 'foo', model.manual_setting
  end

  def test_model_can_override_default_setting_info
    manual_model  = ManualSettingModel.new
    basic_model   = BasicModel.new
    assert manual_model.string_setting != basic_model.string_setting
  end

  def test_model_resonds_to_getters
    [
      BasicModel.new,
      ParentModel.new,
      ChildModel.new,
      JsonColumnModel.new,
      JsonbColumnModel.new,
      CustomColumnModel.new
    ].each do |model|
      %w(string_setting integer_setting boolean_setting boolean_setting?).each do |s|
        assert model.respond_to?(s.to_sym)
      end
    end
  end

  def test_model_resonds_to_setters
    [
      BasicModel.new,
      ParentModel.new,
      ChildModel.new,
      JsonColumnModel.new,
      JsonbColumnModel.new,
      CustomColumnModel.new
    ].each do |model|
      %w(string_setting integer_setting boolean_setting).each do |s|
        assert model.respond_to?("#{s}=".to_sym)
      end
    end
  end

  def test_new_sets_the_settings
    attrs = { string_setting: 'string', integer_setting: 2, boolean_setting: true }
    [
      BasicModel.new(attrs),
      ParentModel.new(attrs),
      ChildModel.new(attrs),
      JsonColumnModel.new(attrs),
      JsonbColumnModel.new(attrs),
      CustomColumnModel.new(attrs)
    ].each do |model|
      assert_equal 'string', model.string_setting
      assert_equal 2, model.integer_setting
      assert_equal true, model.boolean_setting
      assert_equal true, model.boolean_setting?
    end
  end

  def test_create_sets_the_settings
    attrs = { string_setting: 'string', integer_setting: 2, boolean_setting: true }
    [
      BasicModel.create!(attrs),
      ParentModel.create!(attrs),
      ChildModel.create!(attrs),
      JsonColumnModel.create!(attrs),
      JsonbColumnModel.create!(attrs),
      CustomColumnModel.create!(attrs)
    ].each do |model|
      assert_equal 'string', model.string_setting
      assert_equal 2, model.integer_setting
      assert_equal true, model.boolean_setting
      assert_equal true, model.boolean_setting?
    end
  end

  def test_update_updates_the_settings
    [
      BasicModel.new,
      ParentModel.new,
      ChildModel.new,
      JsonColumnModel.new,
      JsonbColumnModel.new,
      CustomColumnModel.new
    ].each do |model|
      assert_nil model.string_setting
      assert_nil model.integer_setting
      assert_nil model.boolean_setting
      assert_nil model.boolean_setting?
      model.update!(string_setting: 'string', integer_setting: 2, boolean_setting: true)
      assert_equal 'string', model.string_setting
      assert_equal 2, model.integer_setting
      assert_equal true, model.boolean_setting
      assert_equal true, model.boolean_setting?
    end
  end

  def test_model_with_validation_triggers_validation
    model = WithValidationModel.new
    refute model.valid?
    assert model.errors[:string_setting].present?
  end
end
