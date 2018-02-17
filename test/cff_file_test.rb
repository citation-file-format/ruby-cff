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

class CFFFileTest < Minitest::Test
  include TestConstruct::Helpers

  def test_new_file_from_model
    title = "software"
    model = ::CFF::Model.new(title)
    file = ::CFF::File.new(model)

    assert_equal file.cff_version, ::CFF::DEFAULT_SPEC_VERSION
    assert_equal file.title, title
  end

  def test_new_file_from_title
    title = "software"
    file = ::CFF::File.new(title)

    assert_equal file.cff_version, ::CFF::DEFAULT_SPEC_VERSION
    assert_equal file.title, title
  end

  def test_read_complete_cff_file
    file = ::CFF::File.read(COMPLETE_CFF)
    assert_equal file.cff_version, '1.0.3'
    assert_equal file.title, 'Citation File Format 1.0.0'
  end

  def test_write_cff_file_from_string
    model = ::CFF::Model.new("software")
    within_construct(CONSTRUCT_OPTS) do |construct|
      ::CFF::File.write(OUTPUT_CFF, model.to_yaml)
      check_file_contents(OUTPUT_CFF, "cff-version")
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, false)
    end
  end

  def test_write_cff_file_from_model
    model = ::CFF::Model.new("software")
    within_construct(CONSTRUCT_OPTS) do |construct|
      ::CFF::File.write(OUTPUT_CFF, model)
      check_file_contents(OUTPUT_CFF, "cff-version")
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, false)
    end
  end

  private

  def check_file_contents(file, contents, exists = true)
    file = ::File.read(file)

    if exists
      assert file.include?(contents)
    else
      refute file.include?(contents)
    end
  end
end
