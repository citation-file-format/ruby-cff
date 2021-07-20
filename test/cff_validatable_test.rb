# frozen_string_literal: true

# Copyright (c) 2018-2021 The Ruby Citation File Format Developers.
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

require 'test_helper'

class CFFValidatableTest < Minitest::Test

  def test_minimal_example_file_validates_without_raising_error
    cff = ::CFF::File.read(MINIMAL_CFF)
    cff.validate!
  end

  def test_minimal_example_file_validates
    cff = ::CFF::File.read(MINIMAL_CFF)
    result = cff.validate

    assert(result[0])
    assert_empty(result[1])
  end

  def test_short_example_file_validates_without_raising_error
    cff = ::CFF::File.read(SHORT_CFF)
    cff.validate!
  end

  def test_short_example_file_validates
    cff = ::CFF::File.read(SHORT_CFF)
    result = cff.validate

    assert(result[0])
    assert_empty(result[1])
  end

  def test_incomplete_example_file_raises_error
    cff = ::CFF::File.read(INCOMPLETE_CFF)
    assert_raises(::CFF::ValidationError) do
      cff.validate!
    end
  end

  def test_incomplete_example_file_lists_correct_error
    cff = ::CFF::File.read(INCOMPLETE_CFF)
    result = cff.validate

    refute(result[0])
    refute_empty(result[1])
    assert_equal(1, result[1].length)

    error = result[1][0]
    assert_instance_of(::JsonSchema::ValidationError, error)
    assert_equal(:required_failed, error.type)
  end

  def test_file_validate
    assert_equal([true, []], ::CFF::File.validate(MINIMAL_CFF))
    result = ::CFF::File.validate(INCOMPLETE_CFF)

    refute(result[0])
    refute_empty(result[1])
    assert_equal(1, result[1].length)

    error = result[1][0]
    assert_instance_of(::JsonSchema::ValidationError, error)
    assert_equal(:required_failed, error.type)
  end

  def test_file_validate!
    assert_nil(::CFF::File.validate!(MINIMAL_CFF))

    assert_raises(::CFF::ValidationError) do
      ::CFF::File.validate!(INCOMPLETE_CFF)
    end
  end

  def test_validate_model
    cff = ::CFF::Model.new('My software')
    assert_raises(::CFF::ValidationError) do
      cff.validate!
    end

    cff.authors << ::CFF::Person.new('Robert', 'Haines')
    cff.validate!
  end
end
