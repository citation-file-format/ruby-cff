# frozen_string_literal: true

require 'test_helper'

class CFFCslFormatterTest < Minitest::Test

  include ::CFF::Util

  describe 'all apa fixtures' do
    Dir[::File.join(FILES_DIR, '*.cff')].each do |input_file|
      define_method("test_converter_for_#{File.basename(input_file)}") do
        cff = ::CFF::File.read(input_file)
        output_file = ::File.join(CONVERTED_DIR, "#{File.basename(input_file, '.*')}.apa")

        assert_equal File.read(output_file).strip!, cff.to_apa
      end
    end
  end

  describe 'all harvard fixtures' do
    Dir[::File.join(FILES_DIR, '*.cff')].each do |input_file|
      define_method("test_converter_for_#{File.basename(input_file)}") do
        cff = ::CFF::File.read(input_file)
        output_file = ::File.join(CONVERTED_DIR, "#{File.basename(input_file, '.*')}.harvard")

        assert_equal File.read(output_file).strip!, cff.to_harvard
      end
    end
  end

  describe 'all ieee fixtures' do
    Dir[::File.join(FILES_DIR, '*.cff')].each do |input_file|
      define_method("test_converter_for_#{File.basename(input_file)}") do
        cff = ::CFF::File.read(input_file)
        output_file = ::File.join(CONVERTED_DIR, "#{File.basename(input_file, '.*')}.ieee")

        assert_equal File.read(output_file).strip!, cff.to_ieee
      end
    end
  end

  def test_all_supported_styles_installed
    assert_equal ['ieee.csl', 'harvard-cite-them-right.csl', 'apa.csl'], (Dir.glob('lib/styles/*.csl').map { |f| f.split('/').last })
  end

  # unsupported styles should return nil
  def test_handle_unsupported_style
    model = ::CFF::Model.new('title')
    assert_nil CFF::CslFormatter.format(model: model, style: 'mla')
  end

  def test_can_tolerate_invalid_file
    cff = CFF::Model.new(nil)
    assert_nil cff.to_apa
  end

  describe 'get_date_parts' do
    def test_year_month_day
      assert_equal({ 'date-parts' => [[2021, 2, 3]] }, ::CFF::CslFormatter.get_date_parts('2021-02-03'))
    end

    def test_year_month
      assert_equal({ 'date-parts' => [[2021, 2]] }, ::CFF::CslFormatter.get_date_parts('2021-02'))
    end

    def test_year
      assert_equal({ 'date-parts' => [[2021]] }, ::CFF::CslFormatter.get_date_parts('2021'))
    end
  end
end
