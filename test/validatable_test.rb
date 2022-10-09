# frozen_string_literal: true

# Copyright (c) 2018-2022 The Ruby Citation File Format Developers.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative 'test_helper'

require 'cff/errors'
require 'cff/index'
require 'cff/file'

class CFFValidatableTest < Minitest::Test
  def test_minimal_example_file_validate!
    cff = ::CFF::File.read(MINIMAL_CFF)

    assert_raises(::CFF::ValidationError) do
      cff.validate!
    end

    cff.validate!(fail_on_filename: false)
  end

  def test_minimal_example_file_validate
    cff = ::CFF::File.read(MINIMAL_CFF)

    result = cff.validate
    refute(result[0])
    assert_empty(result[1])
    refute(result[2])

    result = cff.validate(fail_on_filename: false)
    assert(result[0])
    assert_empty(result[1])
    refute(result[2])
  end

  def test_short_example_file_validate!
    cff = ::CFF::File.read(SHORT_CFF)

    assert_raises(::CFF::ValidationError) do
      cff.validate!
    end

    cff.validate!(fail_on_filename: false)
  end

  def test_short_example_file_validate
    cff = ::CFF::File.read(SHORT_CFF)

    result = cff.validate
    refute(result[0])
    assert_empty(result[1])
    refute(result[2])

    result = cff.validate(fail_on_filename: false)
    assert(result[0])
    assert_empty(result[1])
    refute(result[2])
  end

  def test_empty_cff_version_raises_error
    cff = ::CFF::File.read(MINIMAL_CFF)
    cff.cff_version = ''
    assert_raises(::CFF::ValidationError) do
      cff.validate!(fail_on_filename: false)
    end
  end

  def test_nil_cff_version_raises_error
    cff = ::CFF::File.read(MINIMAL_CFF)
    cff.cff_version = nil
    assert_raises(::CFF::ValidationError) do
      cff.validate!(fail_on_filename: false)
    end
  end

  def test_missing_cff_version_raises_error
    cff = ::CFF::File.read(NO_CFF_VERSION_CFF)
    assert_equal('', cff.cff_version)
    assert_raises(::CFF::ValidationError) do
      cff.validate!(fail_on_filename: false)
    end
  end

  def test_incomplete_example_file_raises_error
    cff = ::CFF::File.read(INCOMPLETE_CFF)
    assert_raises(::CFF::ValidationError) do
      cff.validate!(fail_on_filename: false)
    end
  end

  def test_incomplete_example_file_lists_correct_error
    cff = ::CFF::File.read(INCOMPLETE_CFF)
    result = cff.validate

    refute(result[0])
    refute_empty(result[1])
    refute(result[2])
    assert_equal(1, result[1].length)

    error = result[1][0]
    assert_instance_of(::JsonSchema::ValidationError, error)
    assert_equal(:required_failed, error.type)
  end

  def test_file_validate
    assert_equal([false, [], false], ::CFF::File.validate(MINIMAL_CFF))
    assert_equal(
      [true, [], false],
      ::CFF::File.validate(MINIMAL_CFF, fail_on_filename: false)
    )

    result = ::CFF::File.validate(NO_CFF_VERSION_CFF)
    refute(result[0])
    refute_empty(result[1])
    assert(result[2])
    assert_equal(1, result[1].length)

    error = result[1][0]
    assert_instance_of(::JsonSchema::ValidationError, error)
    assert_equal(:required_failed, error.type)
  end

  def test_file_validate!
    error = assert_raises(::CFF::ValidationError) do
      ::CFF::File.validate!(MINIMAL_CFF)
    end
    assert(error.invalid_filename)

    assert_nil(::CFF::File.validate!(MINIMAL_CFF, fail_on_filename: false))

    # Don't raise error on invalid filename, but it should be detected.
    error = assert_raises(::CFF::ValidationError) do
      ::CFF::File.validate!(INCOMPLETE_CFF, fail_on_filename: false)
    end
    assert(error.invalid_filename)

    # Filename is good, but contents are bad.
    error = assert_raises(::CFF::ValidationError) do
      ::CFF::File.validate!(NO_CFF_VERSION_CFF)
    end
    refute(error.invalid_filename)
  end

  def test_validate_model
    cff = ::CFF::Index.new('My software')

    error = assert_raises(::CFF::ValidationError) do
      cff.validate!
    end
    refute(error.invalid_filename)

    cff.authors << ::CFF::Person.new('Robert', 'Haines')
    cff.validate!
  end

  def test_files_in_validation_directory
    Dir[::File.join(VALIDATION_DIR, '*.cff')].each do |input_file|
      ::CFF::File.validate!(input_file, fail_on_filename: false)
    end
  end

  def test_valid_filename_validates
    cff = ::CFF::File.read(VALID_FILENAME_CFF)

    cff.validate!
    result = cff.validate
    assert(result[0])
    assert_empty(result[1])
    assert(result[2])
  end
end
