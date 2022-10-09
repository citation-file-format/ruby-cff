# frozen_string_literal: true

require_relative '../test_helper'

require 'cff/formatters/apalike'
require 'cff/file'

class CFFApaFormatterTest < Minitest::Test
  describe 'all apa fixtures' do
    Dir[::File.join(FORMATTER_DIR, '*.cff')].each do |input_file|
      define_method("test_converter_for_#{File.basename(input_file)}") do
        cff = ::CFF::File.read(input_file)
        output_file = ::File.join(FORMATTED_DIR, "#{File.basename(input_file, '.*')}.apa")

        if ::File.exist?(output_file)
          assert_equal File.read(output_file).strip, cff.to_apalike
        else
          assert_nil cff.to_apalike
        end
      end
    end
  end

  def test_formatter_label
    assert_equal('APALike', CFF::Formatters::APALike.label)
  end

  def test_can_tolerate_invalid_file
    cff = CFF::Index.new(nil)
    assert_nil cff.to_apalike
  end

  def test_type_label_from_model
    index = ::CFF::Index.new('Title')
    assert_equal(
      ' [Computer software]', CFF::Formatters::APALike.type_label(index)
    )

    index.type = 'wrong'
    assert_equal(
      ' [Computer software]', CFF::Formatters::APALike.type_label(index)
    )

    index.type = 'software'
    assert_equal(
      ' [Computer software]', CFF::Formatters::APALike.type_label(index)
    )

    index.type = 'dataset'
    assert_equal(
      ' [Data set]', CFF::Formatters::APALike.type_label(index)
    )
  end

  def test_type_label_from_reference
    ref = ::CFF::Reference.new('Title')
    assert_equal('', CFF::Formatters::APALike.type_label(ref))

    ref.type = 'book'
    assert_equal('', CFF::Formatters::APALike.type_label(ref))

    ref.type = 'software'
    assert_equal(
      ' [Computer software]', CFF::Formatters::APALike.type_label(ref)
    )

    ref.type = 'software-container'
    assert_equal(
      ' [Computer software]', CFF::Formatters::APALike.type_label(ref)
    )

    ref.type = 'database'
    assert_equal(' [Data set]', CFF::Formatters::APALike.type_label(ref))
  end

  def test_month_and_year_from_model
    date = Date.new(2021, 9, 21)
    conf = ::CFF::Entity.new('Conference')
    ref = ::CFF::Reference.new('Title', 'conference-paper')
    ref.year = 2019
    ref.month = 12

    # Conference type reference with no conference set.
    assert_equal('2019', CFF::Formatters::APALike.month_and_year_from_model(ref))

    # Conference set, but no start date.
    ref.conference = conf
    assert_equal('2019', CFF::Formatters::APALike.month_and_year_from_model(ref))

    # Conference with a start date but no end date.
    conf.date_start = date
    assert_equal('2021', CFF::Formatters::APALike.month_and_year_from_model(ref))

    # Conference with the same start and end date.
    conf.date_end = date
    assert_equal('2021', CFF::Formatters::APALike.month_and_year_from_model(ref))

    # Conference with a different start and end date.
    conf.date_end = date + 5
    assert_equal(
      '2021, September 21–26',
      CFF::Formatters::APALike.month_and_year_from_model(ref)
    )

    # Conference with earlier end date than start date (bad range).
    conf.date_end = date - 1
    assert_equal('2021', CFF::Formatters::APALike.month_and_year_from_model(ref))
  end

  def test_date_range
    start = Date.new(2021, 9, 21)
    finish = start + 3
    assert_equal(
      '2021, September 21–24', CFF::Formatters::APALike.date_range(start, finish)
    )

    finish = start + 10
    assert_equal(
      '2021, September 21–October 1',
      CFF::Formatters::APALike.date_range(start, finish)
    )

    start = Date.new(1999, 12, 31)
    finish = Date.new(2000, 1, 1)
    assert_equal(
      '1999, December 31–2000, January 1',
      CFF::Formatters::APALike.date_range(start, finish)
    )
  end
end
