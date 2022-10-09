# frozen_string_literal: true

require_relative '../test_helper'

require 'cff/formatters/bibtex'
require 'cff/file'

class CFFBibtexFormatterTest < Minitest::Test
  describe 'all bibtex fixtures' do
    Dir[::File.join(FORMATTER_DIR, '*.cff')].each do |input_file|
      define_method("test_converter_for_#{File.basename(input_file)}") do
        cff = ::CFF::File.read(input_file)
        output_file = ::File.join(FORMATTED_DIR, "#{File.basename(input_file, '.*')}.bibtex")

        if ::File.exist?(output_file)
          assert_equal File.read(output_file).strip, cff.to_bibtex
        else
          assert_nil cff.to_bibtex
        end
      end
    end
  end

  def test_formatter_label
    assert_equal('BibTeX', CFF::Formatters::BibTeX.label)
  end

  def test_can_tolerate_invalid_file
    cff = CFF::Index.new(nil)
    assert_nil cff.to_bibtex
  end

  def test_bibtex_type
    index = ::CFF::Index.new('Title')
    assert_equal('software', CFF::Formatters::BibTeX.bibtex_type(index))

    index.type = 'software'
    assert_equal('software', CFF::Formatters::BibTeX.bibtex_type(index))

    index.type = 'dataset'
    assert_equal('misc', CFF::Formatters::BibTeX.bibtex_type(index))

    ref = ::CFF::Reference.new('Title')
    assert_equal('misc', CFF::Formatters::BibTeX.bibtex_type(ref))

    ref.type = 'newspaper-article'
    assert_equal('article', CFF::Formatters::BibTeX.bibtex_type(ref))

    ref.type = 'conference'
    assert_equal('proceedings', CFF::Formatters::BibTeX.bibtex_type(ref))

    ref.type = 'conference-paper'
    assert_equal('inproceedings', CFF::Formatters::BibTeX.bibtex_type(ref))

    ref.type = 'proceedings'
    assert_equal('proceedings', CFF::Formatters::BibTeX.bibtex_type(ref))

    ref.type = 'pamphlet'
    assert_equal('booklet', CFF::Formatters::BibTeX.bibtex_type(ref))

    ['article', 'book', 'manual', 'unpublished'].each do |type|
      ref.type = type
      assert_equal(type, CFF::Formatters::BibTeX.bibtex_type(ref))
    end
  end

  def test_generate_citekey
    [
      [
        {
          'author' => 'von Haines, Jr, Robert and Robert, Haines',
          'title' => 'My Family and Other Animals',
          'year' => '2021'
        },
        'von_Haines_My_Family_and_2021'
      ],
      [
        {
          'year' => nil,
          'author' => '{An Organisation}',
          'title' => "Really?! 'Everyone' Disagrees?"
        },
        'An_Organisation_Really_Everyone_Disagrees'
      ],
      [
        {
          'author' => 'Solskjær, Ole Gunnar',
          'title' => 'My Straße',
          'year' => '2021'
        },
        'Solskjaer_My_Strasse_2021'
      ]
    ].each do |fields, reference|
      assert_equal(reference, CFF::Formatters::BibTeX.generate_citekey(fields))
    end
  end
end
