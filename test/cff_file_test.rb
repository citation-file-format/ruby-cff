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

class CFFFileTest < Minitest::Test

  include TestConstruct::Helpers
  include ::CFF::Util

  def test_bad_methods_not_passed_to_model
    f = ::CFF::File.new('')

    refute f.respond_to?(:aaaaaaa)
    assert_raises(NoMethodError) do
      f.aaaaaaa
    end

    refute f.respond_to?(:Message)
    assert_raises(NoMethodError) do
      f.Message = 'hello'
    end
  end

  def test_new_file_from_model
    title = 'software'
    model = ::CFF::Model.new(title)
    file = ::CFF::File.new(model)

    assert_equal file.cff_version, ::CFF::DEFAULT_SPEC_VERSION
    assert_equal file.title, title
  end

  def test_new_file_from_title
    title = 'software'
    file = ::CFF::File.new(title)

    assert_equal file.cff_version, ::CFF::DEFAULT_SPEC_VERSION
    assert_equal file.title, title
  end

  def test_read_minimal_cff_file
    cff = ::CFF::File.read(MINIMAL_CFF)
    yaml = YAML.load_file(MINIMAL_CFF)
    yaml.default = ''

    methods = %w[
      abstract
      cff_version
      commit
      date_released
      doi
      license
      license_url
      message
      repository
      repository_artifact
      repository_code
      title
      url
      version
    ]

    methods.each do |method|
      assert_equal cff.send(method), yaml[method_to_field(method)]
    end

    assert_equal cff.authors.length, 1
    person = cff.authors[0]
    assert_instance_of ::CFF::Person, person
    assert_equal person.family_names, 'Haines'
    assert_equal person.affiliation, 'The University of Manchester, UK'

    assert_equal cff.contact.length, 0
    assert_equal cff.keywords.length, 0
    assert_equal cff.references.length, 0

    assert_equal cff.comment,
                 ['A minimal CFF file with only the required fields included.']
  end

  def test_read_short_cff_file
    cff = ::CFF::File.read(SHORT_CFF)
    yaml = YAML.load_file(SHORT_CFF)
    yaml.default = ''

    methods = %w[
      abstract
      cff_version
      commit
      date_released
      doi
      keywords
      license
      license_url
      message
      repository
      repository_artifact
      repository_code
      title
      url
      version
    ]

    methods.each do |method|
      assert_equal cff.send(method), yaml[method_to_field(method)]
    end

    assert_equal cff.authors.length, 1
    person = cff.authors[0]
    assert_instance_of ::CFF::Person, person
    assert_equal person.family_names, 'Haines'
    assert_equal person.affiliation, 'The University of Manchester, UK'

    assert_equal cff.contact.length, 0
    assert_equal cff.keywords.length, 3
    assert_equal cff.references.length, 0

    assert_equal cff.comment, ['An incomplete CFF file']
  end

  def test_read_complete_cff_file
    cff = ::CFF::File.read(COMPLETE_CFF)
    yaml = YAML.load_file(COMPLETE_CFF)

    methods = %w[
      abstract
      cff_version
      commit
      date_released
      doi
      keywords
      license
      license_url
      message
      repository
      repository_artifact
      repository_code
      title
      url
      version
    ]

    methods.each do |method|
      assert_equal cff.send(method), yaml[method_to_field(method)]
    end

    assert_equal cff.keywords.length, 4

    assert_equal cff.references.length, 1
    reference = cff.references[0]
    assert_instance_of ::CFF::Reference, reference
    assert_equal reference.type, 'book'
    assert_equal reference.title, 'Book Title'

    [
      cff.authors,
      cff.contact,
      reference.authors,
      reference.contact,
      reference.editors,
      reference.editors_series,
      reference.recipients,
      reference.senders,
      reference.translators
    ].each do |list|
      assert_equal list.length, 2
      person = list[0]
      entity = list[1]

      assert_instance_of ::CFF::Person, person
      assert_equal person.family_names, 'Real Person'
      assert_equal person.affiliation, 'Excellent University, Niceplace, Arcadia'
      assert_instance_of ::CFF::Entity, entity
      assert_equal entity.name, 'Entity Project Team Conference entity'
      assert_equal entity.address, '22 Acacia Avenue'
    end
  end

  def test_write_cff_file_from_string
    model = ::CFF::Model.new('software')
    model.version = '1.0.0'
    model.date_released = '1999-12-31'
    within_construct(CONSTRUCT_OPTS) do
      ::CFF::File.write(OUTPUT_CFF, model.to_yaml)
      check_file_contents(OUTPUT_CFF, 'cff-version')
      check_file_contents(OUTPUT_CFF, 'date-released: 1999-12-31')
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, false)
      check_file_contents(OUTPUT_CFF, 'version: 1.0.0')
      check_file_comment(OUTPUT_CFF, [])
    end
  end

  def test_write_cff_file_from_model
    model = ::CFF::Model.new('software')
    model.version = '1.0.0'
    model.date_released = '1999-12-31'
    within_construct(CONSTRUCT_OPTS) do
      ::CFF::File.write(OUTPUT_CFF, model)
      check_file_contents(OUTPUT_CFF, 'cff-version')
      check_file_contents(OUTPUT_CFF, 'date-released: 1999-12-31')
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, false)
      check_file_contents(OUTPUT_CFF, 'version: 1.0.0')
      check_file_comment(OUTPUT_CFF, [])
    end
  end

  def test_write_cff_file_from_file
    comment = 'Test comment.'
    model = ::CFF::Model.new('software')
    model.version = '1.0.0'
    model.date_released = '1999-12-31'

    file = ::CFF::File.new(model, comment)
    assert_equal file.comment, comment

    within_construct(CONSTRUCT_OPTS) do
      file.write(OUTPUT_CFF)
      check_file_contents(OUTPUT_CFF, 'cff-version')
      check_file_contents(OUTPUT_CFF, 'date-released: 1999-12-31')
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, false)
      check_file_contents(OUTPUT_CFF, 'version: 1.0.0')
      check_file_comment(OUTPUT_CFF, [comment])
    end
  end

  def test_format_comment_array
    before = ['A multi-line', '', 'comment.']
    after = "# A multi-line\n#\n# comment.\n\n"

    assert_equal ::CFF::File.format_comment([]), ''
    assert_equal ::CFF::File.format_comment(before), after
  end

  def test_format_comment_string
    before = 'A very 01234567890123456789012345678901234567890123456789012345678901234567890123456789 long comment'
    after = "# A very 01234567890123456789012345678901234567890123456789012345678901234567\n# 890123456789 long comment\n\n"

    assert_equal ::CFF::File.format_comment(''), ''
    assert_equal ::CFF::File.format_comment(before), after
  end

  def test_parse_comment
    before_s = "###   A comment#.\n"
    after_s = ['A comment#.']
    before_m = "###\n# A   \n### multi-line\n#    comment with #s\n\n# More"
    after_m = ['', 'A', 'multi-line', 'comment with #s']

    assert_equal ::CFF::File.parse_comment(''), []
    assert_equal ::CFF::File.parse_comment(before_s), after_s
    assert_equal ::CFF::File.parse_comment(before_m), after_m
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

  def check_file_comment(file, comment)
    file = ::File.read(file)

    assert_equal ::CFF::File.parse_comment(file), comment
  end
end
