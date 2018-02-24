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

  def test_bad_methods_not_passed_to_model
    f = ::CFF::File.new("")

    assert_raises(NoMethodError) do
      f.aaaaaaa
    end

    assert_raises(NoMethodError) do
      f.Message = "hello"
    end
  end

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
    cff = ::CFF::File.read(COMPLETE_CFF)
    yaml = YAML.load_file(COMPLETE_CFF)

    assert_equal cff.cff_version, yaml["cff-version"]
    assert_equal cff.date_released, yaml["date-released"]
    assert_equal cff.message, yaml["message"]
    assert_equal cff.title, yaml["title"]
    assert_equal cff.version, yaml["version"]
    assert_equal cff.abstract, yaml["abstract"]
    assert_equal cff.commit, yaml["commit"]
    assert_equal cff.doi, yaml["doi"]

    assert_equal cff.authors.length, 2
    assert_instance_of ::CFF::Person, cff.authors[0]
    assert_instance_of ::CFF::Entity, cff.authors[1]

    assert_equal cff.contact.length, 2
    assert_instance_of ::CFF::Person, cff.contact[0]
    assert_instance_of ::CFF::Entity, cff.contact[1]

    assert_equal cff.keywords.length, 4
    assert_equal cff.keywords, yaml["keywords"]
  end

  def test_write_cff_file_from_string
    model = ::CFF::Model.new("software")
    model.version = "1.0.0"
    model.date_released = "1999-12-31"
    within_construct(CONSTRUCT_OPTS) do |construct|
      ::CFF::File.write(OUTPUT_CFF, model.to_yaml)
      check_file_contents(OUTPUT_CFF, "cff-version")
      check_file_contents(OUTPUT_CFF, "date-released: 1999-12-31")
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, false)
      check_file_contents(OUTPUT_CFF, "version: 1.0.0")
    end
  end

  def test_write_cff_file_from_model
    model = ::CFF::Model.new("software")
    model.version = "1.0.0"
    model.date_released = "1999-12-31"
    within_construct(CONSTRUCT_OPTS) do |construct|
      ::CFF::File.write(OUTPUT_CFF, model)
      check_file_contents(OUTPUT_CFF, "cff-version")
      check_file_contents(OUTPUT_CFF, "date-released: 1999-12-31")
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, false)
      check_file_contents(OUTPUT_CFF, "version: 1.0.0")
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
