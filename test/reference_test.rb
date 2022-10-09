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

require 'cff/reference'
require 'cff/file'

class CFFReferenceTest < Minitest::Test
  include TestUtil

  def setup
    @reference = ::CFF::Reference.new('A Paper', 'article')
  end

  def test_bad_methods_not_allowed
    refute_respond_to(@reference, :aaaaaaa)
    assert_raises(NoMethodError) do
      @reference.aaaaaaa
    end

    refute_respond_to(@reference, :Type)
    assert_raises(NoMethodError) do
      @reference.Type = 'book'
    end
  end

  def test_person_entity_fields_set_and_output_correctly
    methods = %w[
      authors
      contact
      editors
      editors_series
      recipients
      senders
      translators
    ]

    methods.each do |method|
      a = ::CFF::Person.new('First', 'Second')
      e = ::CFF::Entity.new('Company')
      @reference.send(method) << a
      @reference.send(method) << '_ _ _'
      @reference.send(method) << e
      assert_equal(3, @reference.send(method).length)
    end

    y = @reference.fields.to_yaml
    refute_includes(y, '_ _ _')

    methods.each do |method|
      assert_equal(2, @reference.send(method).length)
      assert_includes(
        y,
        "#{method_to_field(method)}:\n- family-names: Second\n  given-names: First\n- name: Company\n"
      )
    end
  end

  def test_type_restricted_to_allowed_types
    ref = ::CFF::Reference.new('Title')
    assert_equal('generic', ref.type)

    ref = ::CFF::Reference.new('Title', 'Article')
    assert_equal('article', ref.type)

    ref = ::CFF::Reference.new('Title', 'cake')
    refute_equal('cake', ref.type)
    assert_equal('generic', ref.type)

    @reference.type = 'cake'
    refute_equal('cake', @reference.type)
    assert_equal('article', @reference.type)

    @reference.type = 'Book'
    assert_equal('book', @reference.type)
  end

  def test_status_restricted_to_allowed_types
    @reference.status = 'in-press'
    assert_equal('in-press', @reference.status)

    @reference.status = 'published'
    refute_equal('published', @reference.status)
    assert_equal('in-press', @reference.status)

    @reference.status = 'Preprint'
    assert_equal('preprint', @reference.status)
  end

  def test_languages_methods
    assert_empty(@reference.languages)

    @reference.languages << 'eng'
    assert_empty(@reference.languages)

    @reference.add_language 'english'
    assert_equal(['eng'], @reference.languages)
    @reference.add_language 'GER'
    assert_equal(%w[eng deu], @reference.languages)
    @reference.add_language 'en'
    assert_equal(%w[eng deu], @reference.languages)

    @reference.reset_languages
    assert_empty(@reference.languages)

    @reference.add_language 'Inglish'
    assert_empty(@reference.languages)
  end

  def test_languages_output_correctly
    %w[en GER french Inglish].each do |lang|
      @reference.add_language lang
    end
    y = @reference.fields.to_yaml
    assert_includes(y, "languages:\n- eng\n- deu\n- fra\n")

    @reference.reset_languages
    y = @reference.fields.to_yaml
    refute_includes(y, "languages:\n")
  end

  def test_license_is_set_and_output_correctly
    assert_equal('', @reference.license)

    @reference.license = 'Bad Licence'
    assert_equal('', @reference.license)

    @reference.license = 'Apache-2.0'
    assert_equal('Apache-2.0', @reference.license)

    @reference.license = 'Bad Licence'
    assert_equal('Apache-2.0', @reference.license)

    assert_includes(@reference.fields.to_yaml, "license: Apache-2.0\n")

    @reference.license = ['Bad Licence', 'Apache-2.0']
    assert_equal('Apache-2.0', @reference.license)
    assert_includes(@reference.fields.to_yaml, "license: Apache-2.0\n")

    @reference.license = ['Apache-2.0', 'Ruby']
    assert_equal(['Apache-2.0', 'Ruby'], @reference.license)
    assert_includes(
      @reference.fields.to_yaml,
      "license:\n- Apache-2.0\n- Ruby\n"
    )

    @reference.license = 'Bad Licence'
    assert_equal(['Apache-2.0', 'Ruby'], @reference.license)
  end

  def test_bad_dates_raises_error
    %w[
      date_accessed date_downloaded date_published date_released
    ].each do |method|
      exp = assert_raises(ArgumentError) do
        @reference.send("#{method}=", 'nonsense')
      end
      assert_includes(exp.message, 'invalid date')
    end
  end

  def test_dates_are_set_and_output_correctly
    %w[
      date_accessed date_downloaded date_published date_released issue_date
    ].each do |method|
      date = Date.today
      @reference.send("#{method}=", date)
      assert_equal(date, @reference.send(method))
      y = @reference.fields.to_yaml
      assert_includes(y, "#{method_to_field(method)}: #{date.iso8601}")

      date = '1999-12-31'
      @reference.send("#{method}=", date)
      assert_equal(Date.parse(date), @reference.send(method))
      y = @reference.fields.to_yaml
      assert_includes(y, "#{method_to_field(method)}: #{date}")
    end
  end

  def test_keywords_and_patent_states_set_and_output_correctly
    keys = ['one', :two, 3]

    y = @reference.fields.to_yaml
    refute_includes(y, 'keywords:')
    refute_includes(y, 'patent-states:')

    @reference.keywords = keys.dup
    @reference.patent_states = keys.dup
    l = keys.length
    assert_equal(l, @reference.keywords.length)
    assert_equal(l, @reference.patent_states.length)

    @reference.keywords << 'four'
    @reference.patent_states << 'four'
    l += 1
    assert_equal(l, @reference.keywords.length)
    assert_equal(l, @reference.patent_states.length)

    y = @reference.fields.to_yaml
    assert_equal(l, @reference.keywords.length)
    assert_equal(l, @reference.patent_states.length)
    assert_includes(y, "keywords:\n- one\n- two\n- '3'\n- four\n")
    assert_includes(y, "patent-states:\n- one\n- two\n- '3'\n- four\n")
  end

  def test_simple_fields_set_and_output_correctly
    value = 'a simple string field'
    methods = %w[
      abbreviation
      abstract
      collection_doi
      collection_title
      collection_type
      commit
      copyright
      data_type
      database
      department
      doi
      edition
      entry
      filename
      format
      isbn
      issn
      issue_title
      journal
      license_url
      medium
      nihmsid
      notes
      number
      pmcid
      repository
      repository_code
      repository_artifact
      scope
      section
      term
      thesis_type
      url
      version
      volume_title
    ]

    methods.each do |method|
      assert_equal('', @reference.send(method))
      @reference.send("#{method}=", value)
      assert_equal(value, @reference.send(method))
    end

    y = @reference.fields.to_yaml

    methods.each do |method|
      assert_includes(y, "#{method_to_field(method)}: #{value}\n")
    end
  end

  def test_integer_fields_set_and_output_correctly
    value = 42
    methods = %w[
      end
      issue
      loc-end
      loc-start
      month
      number-volumes
      pages
      start
      volume
      year
      year_original
    ]

    methods.each do |method|
      assert_equal('', @reference.send(method))
      @reference.send("#{method}=", value)
      assert_equal(value, @reference.send(method))
    end

    y = @reference.fields.to_yaml

    methods.each do |method|
      assert_includes(y, "#{method_to_field(method)}: #{value}\n")
    end
  end

  def test_entity_fields_set_and_output_correctly
    methods = %w[conference database_provider institution location publisher]

    methods.each do |method|
      value = ::CFF::Entity.new('Company')
      assert_equal('', @reference.send(method))
      @reference.send("#{method}=", value)
      assert_equal(value, @reference.send(method))
    end

    y = @reference.fields.to_yaml

    methods.each do |method|
      assert_includes(y, "#{method_to_field(method)}:\n  name: Company\n")
    end
  end

  def test_identifiers_set_and_output_correctly
    i = ::CFF::Identifier.new('doi', '10.5281/zenodo.1184077')
    r = [::CFF::Identifier.new('other', 'other-id:00:CFF'), '_ _ _']

    @reference.identifiers << i
    @reference.identifiers << '_ _ _'

    y = @reference.fields.to_yaml
    assert_equal(1, @reference.identifiers.length)
    assert_includes(
      y,
      "identifiers:\n- type: doi\n  value: 10.5281/zenodo.1184077"
    )
    refute_includes(y, '_ _ _')

    @reference.identifiers = r

    y = @reference.fields.to_yaml
    assert_equal(1, @reference.identifiers.length)
    assert_includes(
      y,
      "identifiers:\n- type: other\n  value: other-id:00:CFF"
    )
    refute_includes(y, '_ _ _')
  end

  def test_new_with_block
    ref = ::CFF::Reference.new('A Paper', 'article') do |r|
      assert_equal('A Paper', r.title)
      assert_equal('article', r.type)
      r.conference = 'International Conference of Hard Problems'
    end

    assert_equal('A Paper', ref.title)
    assert_equal('article', ref.type)
    assert_equal('International Conference of Hard Problems', ref.conference)
    assert ref.is_a?(::CFF::Reference)
  end

  def test_from_cff_file
    file = ::CFF::File.read(MINIMAL_CFF)
    ref = ::CFF::Reference.from_cff(file)

    assert_equal('software', ref.type)
    %w[
      abstract authors contact commit date_released doi
      identifiers keywords license license_url repository
      repository_artifact repository_code title url version
    ].each do |field|
      assert_equal(file.send(field), ref.send(field))
    end
  end

  def test_empty?
    refute_empty(@reference)
  end
end
