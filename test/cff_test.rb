require "test_helper"

class CFFTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::CFF::VERSION
  end
end
