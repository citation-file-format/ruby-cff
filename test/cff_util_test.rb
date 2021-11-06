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

class CFFUtilTest < Minitest::Test

  include ::CFF::Util

  def test_update_cff_version
    assert_equal('', update_cff_version(''))
    assert_equal(::CFF::MIN_VALIDATABLE_VERSION, update_cff_version('1.0.3'))
    assert_equal(::CFF::MIN_VALIDATABLE_VERSION, update_cff_version('1.1.0'))
    assert_equal('1.2.0', update_cff_version('1.2.0'))
    assert_equal('1.2.1', update_cff_version('1.2.1'))
  end

  def test_method_to_field
    assert_equal('field', method_to_field('field'))
    assert_equal('field-field', method_to_field('field_field'))
    assert_equal('field-field', method_to_field('field-field'))
  end

  def test_build_actor_collection
    array = [
      { 'family-names' => 'Second', 'given-names' => 'First' },
      { 'name' => 'Company' }
    ]

    build_actor_collection!(array)
    assert_equal(2, array.length)
    assert_instance_of ::CFF::Person, array[0]
    assert_equal('First', array[0].given_names)
    assert_instance_of ::CFF::Entity, array[1]
    assert_equal('Company', array[1].name)
  end

  def test_normalize_modelpart_array
    string = 'some text'
    data = [
      ::CFF::Person.new('First', 'Second'),
      string,
      ::CFF::Entity.new('Company')
    ]

    normalize_modelpart_array!(data)

    assert_equal(2, data.length)
    assert_instance_of ::CFF::Person, data[0]
    assert_instance_of ::CFF::Entity, data[1]
  end

  def test_transliterate
    [
      ['', '', nil],
      [' ', ' ', nil],
      ['abcdefg123456789', 'abcdefg123456789', nil],
      ['!$%^&*()#~@:;<>,./?|-_+={}[]', '!$%^&*()#~@:;<>,./?|-_+={}[]', nil],
      ['"\'\\`', '"\'\\`', nil],
      ['£', '', '?'],
      ['Å×ßĳŋű', 'Axssijngu', nil],
      ['Straße', 'Strasse', nil],
      ['Bùi Viện', 'Bui Vien', nil],
      ['ŠKODA', 'SKODA', nil],
      ['áëëçüñżλφθΩ𠜎😸', 'aeecunz', 'aee?cunz??????'],
      ['雙屬', '', '??'],
      ["\x00\n\x1f\x7f", "\x00\n\x1f\x7f", nil]
    ].each do |before, after, fallback|
      assert_equal(after, ::CFF::Util.transliterate(before))
      assert_equal(
        fallback || after, ::CFF::Util.transliterate(before, fallback: '?')
      )
    end
  end
end
