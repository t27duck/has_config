require 'test_helper'

class HasConfig::ChainTest < Minitest::Test
  def test_invoke_processes_for_blank_checks
    assert_equal true, HasConfig::Chain.invoke?('', :blank)
    assert_equal true, HasConfig::Chain.invoke?(nil, :blank)
    assert_equal true, HasConfig::Chain.invoke?(false, :blank)
    assert_equal false, HasConfig::Chain.invoke?('x', :blank)
    assert_equal false, HasConfig::Chain.invoke?(2, :blank)
    assert_equal false, HasConfig::Chain.invoke?(true, :blank)
  end

  def test_invoke_processes_for_nil_checks
    assert_equal true, HasConfig::Chain.invoke?(nil, :nil)
    assert_equal false, HasConfig::Chain.invoke?('', :nil)
    assert_equal false, HasConfig::Chain.invoke?(false, :nil)
    assert_equal false, HasConfig::Chain.invoke?('x', :nil)
    assert_equal false, HasConfig::Chain.invoke?(2, :nil)
    assert_equal false, HasConfig::Chain.invoke?(true, :nil)
  end

  def test_invoke_processes_for_false_checks
    assert_equal true, HasConfig::Chain.invoke?(false, :false)
    assert_equal false, HasConfig::Chain.invoke?(nil, :false)
    assert_equal false, HasConfig::Chain.invoke?('', :false)
    assert_equal false, HasConfig::Chain.invoke?('x', :false)
    assert_equal false, HasConfig::Chain.invoke?(2, :false)
    assert_equal false, HasConfig::Chain.invoke?(true, :false)
  end
end
