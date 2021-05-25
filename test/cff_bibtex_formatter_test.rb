require 'test_helper'

class CFFBibtexFormatterTest < Minitest::Test

  include ::CFF::Util

  def test_bibtex_minimal
    cff = ::CFF::File.read(MINIMAL_CFF)
    assert_equal File.read(MINIMAL_CFF_BIBTEX), cff.to_bibtex
  end

  def test_bibtex_complete
    cff = ::CFF::File.read(COMPLETE_CFF)
    assert_equal File.read(COMPLETE_CFF_BIBTEX), cff.to_bibtex
  end

  def test_bibtex_short
    cff = ::CFF::File.read(SHORT_CFF)
    assert_equal File.read(SHORT_CFF_BIBTEX), cff.to_bibtex
  end
end
