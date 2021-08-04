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

  def test_can_tolerate_invalid_file
    cff = CFF::Model.new(nil)
    assert_nil cff.to_apalike
  end
end
