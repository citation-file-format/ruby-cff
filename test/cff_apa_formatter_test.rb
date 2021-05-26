require 'test_helper'

class CFFApaFormatterTest < Minitest::Test

  include ::CFF::Util

  def test_can_tolerate_invalid_file
    cff = CFF::Model.new(nil)
    assert_nil cff.to_apalike
  end

  def test_apalike_minimal
    cff = ::CFF::File.read(MINIMAL_CFF)
    assert_equal File.read(MINIMAL_CFF_APALIKE), cff.to_apalike
  end

  def test_apalike_short
    cff = ::CFF::File.read(SHORT_CFF)
    assert_equal File.read(SHORT_CFF_APALIKE), cff.to_apalike
  end

  def test_apalike_complete
    cff = ::CFF::File.read(COMPLETE_CFF)
    assert_equal File.read(COMPLETE_CFF_APALIKE), cff.to_apalike
  end
end
