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
    f = ::CFF::File.new('', '')

    refute_respond_to(f, :aaaaaaa)
    assert_raises(NoMethodError) do
      f.aaaaaaa
    end

    refute_respond_to(f, :Message)
    assert_raises(NoMethodError) do
      f.Message = 'hello'
    end
  end

  def test_new_file_from_model
    title = 'software'
    model = ::CFF::Model.new(title)
    file = ::CFF::File.new('', model)

    assert_equal(::CFF::DEFAULT_SPEC_VERSION, file.cff_version)
    assert_equal(title, file.title)
  end

  def test_new_file_from_title
    title = 'software'
    file = ::CFF::File.new('', title)

    assert_equal(::CFF::DEFAULT_SPEC_VERSION, file.cff_version)
    assert_equal(title, file.title)
  end

  def test_read_minimal_cff_file
    cff = ::CFF::File.read(MINIMAL_CFF)
    yaml = load_yaml(MINIMAL_CFF)
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
      assert_equal(yaml[method_to_field(method)], cff.send(method))
    end

    assert_equal(1, cff.authors.length)
    person = cff.authors[0]
    assert_instance_of ::CFF::Person, person
    assert_equal('Haines', person.family_names)
    assert_equal('The University of Manchester, UK', person.affiliation)

    assert_equal(0, cff.contact.length)
    assert_equal(0, cff.keywords.length)
    assert_equal(0, cff.references.length)

    assert_equal(
      ['A minimal CFF file with only the required fields included.'],
      cff.comment
    )
  end

  def test_read_short_cff_file
    cff = ::CFF::File.read(SHORT_CFF)
    yaml = load_yaml(SHORT_CFF)
    yaml.default = ''

    methods = %w[
      abstract
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
      assert_equal(yaml[method_to_field(method)], cff.send(method))
    end

    # `cff-version` will be updated to a validatable version.
    assert_equal(::CFF::MIN_VALIDATABLE_VERSION, cff.cff_version)

    assert_equal(1, cff.authors.length)
    person = cff.authors[0]
    assert_instance_of ::CFF::Person, person
    assert_equal('Haines', person.family_names)
    assert_equal('The University of Manchester, UK', person.affiliation)

    assert_equal(0, cff.contact.length)
    assert_equal(3, cff.keywords.length)
    assert_equal(0, cff.references.length)

    assert_equal(['An incomplete CFF file'], cff.comment)
  end

  def test_read_complete_cff_file
    cff = ::CFF::File.read(COMPLETE_CFF)
    yaml = load_yaml(COMPLETE_CFF)

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
      assert_equal(yaml[method_to_field(method)], cff.send(method))
    end

    assert_equal(4, cff.identifiers.length)
    cff.identifiers.each do |id|
      assert_instance_of(::CFF::Identifier, id)
    end

    assert_equal(4, cff.keywords.length)

    assert_equal(1, cff.references.length)
    reference = cff.references[0]
    assert_instance_of ::CFF::Reference, reference
    assert_equal('book', reference.type)
    assert_equal('Book Title', reference.title)

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
      assert_equal(2, list.length)
      person = list[0]
      entity = list[1]

      assert_instance_of ::CFF::Person, person
      assert_equal('Real Person', person.family_names)
      assert_equal(
        'Excellent University, Niceplace, Arcadia', person.affiliation
      )
      assert_instance_of ::CFF::Entity, entity
      assert_equal('Entity Project Team Conference entity', entity.name)
      assert_equal('22 Acacia Avenue', entity.address)
    end
  end

  def test_open_minimal_cff_file
    mtime = ::File.mtime(MINIMAL_CFF)
    cff = ::CFF::File.open(MINIMAL_CFF)
    yaml = load_yaml(MINIMAL_CFF)
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
      assert_equal(yaml[method_to_field(method)], cff.send(method))
    end

    assert_equal(1, cff.authors.length)
    person = cff.authors[0]
    assert_instance_of ::CFF::Person, person
    assert_equal('Haines', person.family_names)
    assert_equal('The University of Manchester, UK', person.affiliation)

    assert_equal(0, cff.contact.length)
    assert_equal(0, cff.keywords.length)
    assert_equal(0, cff.references.length)

    assert_equal(
      ['A minimal CFF file with only the required fields included.'],
      cff.comment
    )

    assert_equal(File.mtime(MINIMAL_CFF), mtime)
  end

  def test_open_minimal_cff_file_with_block
    mtime = ::File.mtime(MINIMAL_CFF)
    yaml = load_yaml(MINIMAL_CFF)
    yaml.default = ''

    ::CFF::File.open(MINIMAL_CFF) do |cff|
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
        assert_equal(yaml[method_to_field(method)], cff.send(method))
      end

      assert_equal(1, cff.authors.length)
      person = cff.authors[0]
      assert_instance_of ::CFF::Person, person
      assert_equal('Haines', person.family_names)
      assert_equal('The University of Manchester, UK', person.affiliation)

      assert_equal(0, cff.contact.length)
      assert_equal(0, cff.keywords.length)
      assert_equal(0, cff.references.length)

      assert_equal(
        ['A minimal CFF file with only the required fields included.'],
        cff.comment
      )
    end

    assert_equal(File.mtime(MINIMAL_CFF), mtime)
  end

  def test_open_new_cff_file
    within_construct(CONSTRUCT_OPTS) do
      file = ::CFF::File.open(OUTPUT_CFF)
      file.title = 'software'
      file.version = '1.0.0'
      file.date_released = '1999-12-31'
      file.write

      check_file_contents(OUTPUT_CFF, 'cff-version')
      check_file_contents(OUTPUT_CFF, 'date-released: 1999-12-31')
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, exists: false)
      check_file_contents(OUTPUT_CFF, 'version: 1.0.0')
    end
  end

  def test_open_new_cff_file_with_block
    within_construct(CONSTRUCT_OPTS) do
      ::CFF::File.open(OUTPUT_CFF) do |file|
        file.title = 'software'
        file.version = '1.0.0'
        file.date_released = '1999-12-31'
      end

      check_file_contents(OUTPUT_CFF, 'cff-version')
      check_file_contents(OUTPUT_CFF, 'date-released: 1999-12-31')
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, exists: false)
      check_file_contents(OUTPUT_CFF, 'version: 1.0.0')
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
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, exists: false)
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
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, exists: false)
      check_file_contents(OUTPUT_CFF, 'version: 1.0.0')
      check_file_comment(OUTPUT_CFF, [])
    end
  end

  def test_write_cff_file_from_file
    comment = 'Test comment.'
    model = ::CFF::Model.new('software')
    model.version = '1.0.0'
    model.date_released = '1999-12-31'

    file = ::CFF::File.new(OUTPUT_CFF, model, comment, create: true)
    assert_equal file.comment, comment

    within_construct(CONSTRUCT_OPTS) do
      file.write
      check_file_contents(OUTPUT_CFF, 'cff-version')
      check_file_contents(OUTPUT_CFF, 'date-released: 1999-12-31')
      check_file_contents(OUTPUT_CFF, ::CFF::File::YAML_HEADER, exists: false)
      check_file_contents(OUTPUT_CFF, 'version: 1.0.0')
      check_file_comment(OUTPUT_CFF, [comment])
    end
  end

  def test_format_comment_array
    before = ['A multi-line', '', 'comment.']
    after = "# A multi-line\n#\n# comment.\n\n"

    assert_equal('', ::CFF::File.format_comment([]))
    assert_equal(after, ::CFF::File.format_comment(before))
  end

  def test_format_comment_string
    before = 'A very 01234567890123456789012345678901234567890123456789012345678901234567890123456789 long comment'
    after = "# A very 01234567890123456789012345678901234567890123456789012345678901234567\n# 890123456789 long comment\n\n"

    assert_equal('', ::CFF::File.format_comment(''))
    assert_equal(after, ::CFF::File.format_comment(before))
  end

  def test_parse_comment
    before_s = "###   A comment#.\n"
    after_s = ['A comment#.']
    before_m = "###\n# A   \n### multi-line\n#    comment with #s\n\n# More"
    after_m = ['', 'A', 'multi-line', 'comment with #s']

    assert_empty(::CFF::File.parse_comment(''))
    assert_equal(after_s, ::CFF::File.parse_comment(before_s))
    assert_equal(after_m, ::CFF::File.parse_comment(before_m))
  end

  private

  def check_file_contents(file, contents, exists: true)
    file = ::File.read(file)

    if exists
      assert_includes(file, contents)
    else
      refute_includes(file, contents)
    end
  end

  def check_file_comment(file, comment)
    file = ::File.read(file)

    assert_equal(comment, ::CFF::File.parse_comment(file))
  end

  if RUBY_VERSION[0..2].to_f >= 3
    def load_yaml(file)
      YAML.safe_load_file(file, permitted_classes: [Date, Time])
    end
  else
    def load_yaml(file)
      YAML.load_file(file)
    end
  end
end
