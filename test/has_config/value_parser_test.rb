require 'minitest_helper'

class HasConfig::ValueParserTest < Minitest::Test
  def test_true_boolean_values_are_parsed
    ['t', 'true', '1', 1, true].each do |value|
      assert_equal true, HasConfig::ValueParser.parse(value, :boolean),
                   "#{value.inspect} did not parse to true"
    end
  end

  def test_false_boolean_values_are_parsed
    ['f', 'false', '0', 0, false, 'a string', 7].each do |value|
      assert_equal false, HasConfig::ValueParser.parse(value, :boolean),
                   "#{value.inspect} did not parse to false"
    end
  end

  def test_empty_string_for_integer_returns_nil
    assert_equal nil, HasConfig::ValueParser.parse('', :integer)
  end

  def test_integer_is_parsed_to_a_string
    assert_equal '4', HasConfig::ValueParser.parse(4, :string)
  end

  def test_invoke_chain_processes_for_blank_checks
    assert_equal true, HasConfig::ValueParser.invoke_chain?('', :blank)
    assert_equal true, HasConfig::ValueParser.invoke_chain?(nil, :blank)
    assert_equal true, HasConfig::ValueParser.invoke_chain?(false, :blank)
    assert_equal false, HasConfig::ValueParser.invoke_chain?('x', :blank)
    assert_equal false, HasConfig::ValueParser.invoke_chain?(2, :blank)
    assert_equal false, HasConfig::ValueParser.invoke_chain?(true, :blank)
  end

  def test_invoke_chain_processes_for_nil_checks
    assert_equal true, HasConfig::ValueParser.invoke_chain?(nil, :nil)
    assert_equal false, HasConfig::ValueParser.invoke_chain?('', :nil)
    assert_equal false, HasConfig::ValueParser.invoke_chain?(false, :nil)
    assert_equal false, HasConfig::ValueParser.invoke_chain?('x', :nil)
    assert_equal false, HasConfig::ValueParser.invoke_chain?(2, :nil)
    assert_equal false, HasConfig::ValueParser.invoke_chain?(true, :nil)
  end

  def test_invoke_chain_processes_for_false_checks
    assert_equal true, HasConfig::ValueParser.invoke_chain?(false, :false)
    assert_equal false, HasConfig::ValueParser.invoke_chain?(nil, :false)
    assert_equal false, HasConfig::ValueParser.invoke_chain?('', :false)
    assert_equal false, HasConfig::ValueParser.invoke_chain?('x', :false)
    assert_equal false, HasConfig::ValueParser.invoke_chain?(2, :false)
    assert_equal false, HasConfig::ValueParser.invoke_chain?(true, :false)
  end
end
