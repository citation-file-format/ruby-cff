# frozen_string_literal: true

# Copyright (c) 2018-2024 The Ruby Citation File Format Developers.
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

require 'cff/schemas'

class CFFSchemasTest < Minitest::Test
  include CFF::Schemas

  def test_read
    properties = read('properties') do |obj|
      assert_kind_of(Hash, obj)
    end

    assert_kind_of(Array, properties)
  end

  def test_read_defs
    definitions = read_defs('entity', 'properties') do |obj|
      assert_kind_of(Hash, obj)
    end

    assert_kind_of(Array, definitions)
  end

  def test_read_oneof
    definitions = read_oneof('identifier') do |obj|
      assert_kind_of(Array, obj)
    end

    assert_kind_of(Array, definitions)
  end
end
