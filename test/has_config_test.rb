require 'test_helper'

class HasConfigTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::HasConfig::VERSION
  end
end
