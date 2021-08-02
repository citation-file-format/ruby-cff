# frozen_string_literal: true

require 'test_helper'

class CFFBibtexFormatterTest < Minitest::Test

  include ::CFF::Util

  describe 'all bibtex fixtures' do
    Dir[::File.join(FILES_DIR, '*.cff')].each do |input_file|
      define_method("test_converter_for_#{File.basename(input_file)}") do
        cff = ::CFF::File.read(input_file)
        output_file = ::File.join(CONVERTED_DIR, "#{File.basename(input_file, '.*')}.bibtex")

        assert_equal File.read(output_file).strip!, cff.to_bibtex
      end
    end
  end

  def test_can_tolerate_invalid_file
    cff = CFF::Model.new(nil)
    assert_nil cff.to_bibtex
  end

  def test_generate_reference
    [
      [
        {
          'author' => 'von Haines, Robert and Robert, Haines',
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
      ]
    ].each do |fields, reference|
      assert_equal(reference, ::CFF::BibtexFormatter.generate_reference(fields))
    end
  end
end
