# frozen_string_literal: true

require 'test_helper'

class CFFApaFormatterTest < Minitest::Test

  describe 'all apa fixtures' do
    Dir[::File.join(FILES_DIR, '*.cff')].each do |input_file|
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

  def test_can_tolerate_invalid_file
    cff = CFF::Model.new(nil)
    assert_nil cff.to_apalike
  end

  def test_type_label_from_model
    model = ::CFF::Model.new('Title')
    assert_equal(
      ' [Computer software]', ::CFF::ApaFormatter.type_label(model)
    )

    model.type = 'wrong'
    assert_equal(
      ' [Computer software]', ::CFF::ApaFormatter.type_label(model)
    )

    model.type = 'software'
    assert_equal(
      ' [Computer software]', ::CFF::ApaFormatter.type_label(model)
    )

    model.type = 'dataset'
    assert_equal(
      ' [Data set]', ::CFF::ApaFormatter.type_label(model)
    )
  end

  def test_type_label_from_reference
    ref = ::CFF::Reference.new('Title')
    assert_equal('', ::CFF::ApaFormatter.type_label(ref))

    ref.type = 'book'
    assert_equal('', ::CFF::ApaFormatter.type_label(ref))

    ref.type = 'software'
    assert_equal(
      ' [Computer software]', ::CFF::ApaFormatter.type_label(ref)
    )

    ref.type = 'software-container'
    assert_equal(
      ' [Computer software]', ::CFF::ApaFormatter.type_label(ref)
    )

    ref.type = 'database'
    assert_equal(' [Data set]', ::CFF::ApaFormatter.type_label(ref))
  end
end
