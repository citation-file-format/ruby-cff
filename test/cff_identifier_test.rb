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

require 'yaml'
require 'cff/identifier'

class CFFIdentifierTest < Minitest::Test
  def test_new
    id = ::CFF::Identifier.new('doi', '10.5281/zenodo.1184077')
    assert_equal('doi', id.type)
    assert_equal('10.5281/zenodo.1184077', id.value)
  end

  def test_new_with_block
    id = ::CFF::Identifier.new('doi', '10.5281/zenodo.1184077') do |i|
      assert_equal('doi', i.type)
      assert_equal('10.5281/zenodo.1184077', i.value)
      i.value = '10.9999/zenodo.1234567'
    end

    assert_equal('doi', id.type)
    assert_equal('10.9999/zenodo.1234567', id.value)
    assert id.is_a?(::CFF::Identifier)
  end

  def test_new_no_params
    id = ::CFF::Identifier.new
    assert_empty(id.type)
    assert_empty(id.value)
  end

  def test_new_bad_type
    id = ::CFF::Identifier.new('xxx', '0123456789')
    assert_empty(id.type)
    assert_empty(id.value)

    id = ::CFF::Identifier.new('', '0123456789')
    assert_empty(id.type)
    assert_empty(id.value)

    id = ::CFF::Identifier.new(nil, '0123456789')
    assert_empty(id.type)
    assert_empty(id.value)
  end

  def test_bad_methods_not_allowed
    id = ::CFF::Identifier.new

    refute_respond_to(id, :aaaaaaa)
    assert_raises(NoMethodError) do
      id.aaaaaaa
    end

    refute_respond_to(id, :Type)
    assert_raises(NoMethodError) do
      id.Type = 'swh'
    end
  end

  def test_type_restricted_to_allowed_types
    id = ::CFF::Identifier.new

    id.type = 'doi'
    assert_equal('doi', id.type)

    id.type = 'xxx'
    assert_equal('doi', id.type)

    id.type = 'SWH'
    assert_equal('swh', id.type)
  end

  def test_simple_fields_set_and_output_correctly
    id = ::CFF::Identifier.new
    value = 'swh:1:rel:99f6850374dc6597af01bd0ee1d3fc0699301b9f'
    desc = 'Software Heritage ID'

    assert_equal('', id.value)
    id.value = value
    assert_equal(value, id.value)

    assert_equal('', id.description)
    id.description = desc
    assert_equal(desc, id.description)

    y = id.fields.to_yaml

    assert_includes(y, "value: #{value}\n")
    assert_includes(y, "description: #{desc}\n")
  end

  def test_empty?
    id = ::CFF::Identifier.new
    refute_empty(id)
  end
end
