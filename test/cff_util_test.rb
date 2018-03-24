# Copyright (c) 2018 Robert Haines.
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

  def test_delete_from_hash
    h = {one: 1, two: 2, three: 3}

    r = delete_from_hash(h, :rubbish)
    refute_same r, h
    assert_equal r, h

    r = delete_from_hash(h, :one)
    refute_equal r, h
    assert !r.has_key?(:one)
    assert_equal r.size, 2
    assert_equal h.size, 3
  end

  def test_method_to_field
    assert_equal method_to_field("field"), "field"
    assert_equal method_to_field("field_field"), "field-field"
    assert_equal method_to_field("field-field"), "field-field"
  end

  def test_build_actor_collection
    array = [
      {"family-names"=>"Second", "given-names"=>"First"},
      {"name"=>"Company"}
    ]

    build_actor_collection!(array)
    assert_equal array.length, 2
    assert_instance_of ::CFF::Person, array[0]
    assert_equal array[0].given_names, "First"
    assert_instance_of ::CFF::Entity, array[1]
    assert_equal array[1].name, "Company"
  end

  def test_normalize_modelpart_array
    string = "some text"
    data = [
      ::CFF::Person.new('First', 'Second'),
      string,
      ::CFF::Entity.new('Company')
    ]

    normalize_modelpart_array!(data)

    assert_equal data.length, 2
    assert_instance_of ::CFF::Person, data[0]
    assert_instance_of ::CFF::Entity, data[1]
  end
end
