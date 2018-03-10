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

require "test_helper"

class CFFReferenceTest < Minitest::Test
  include ::CFF::Util

  def setup
    @reference = ::CFF::Reference.new("A Paper", "article")
  end

  def test_bad_methods_not_allowed
    assert_raises(NoMethodError) do
      @reference.aaaaaaa
    end

    assert_raises(NoMethodError) do
      @reference.Type = "book"
    end
  end

  def test_person_entity_fields_set_and_output_correctly
    methods = [
      'authors',
      'contact',
      'editors',
      'editors_series',
      'recipients',
      'senders',
      'translators'
    ]

    methods.each do |method|
      a = ::CFF::Person.new('First', 'Second')
      e = ::CFF::Entity.new('Company')
      @reference.send(method) << a
      @reference.send(method) << "_ _ _"
      @reference.send(method) << e
      assert_equal (@reference.send(method)).length, 3
    end

    y = @reference.fields.to_yaml
    refute y.include? "_ _ _"

    methods.each do |method|
      assert_equal (@reference.send(method)).length, 3
      assert y.include? "#{method_to_field(method)}:\n- family-names: Second\n  given-names: First\n- name: Company\n"
    end
  end

  def test_type_restricted_to_allowed_types
    ref = ::CFF::Reference.new("Title", "cake")
    refute_equal ref.type, "cake"
    assert_equal ref.type, "generic"

    @reference.type = "cake"
    refute_equal @reference.type, "cake"
    assert_equal @reference.type, "article"
  end

  def test_status_restricted_to_allowed_types
    @reference.status = "in-press"
    assert_equal @reference.status, "in-press"

    @reference.status = "published"
    refute_equal @reference.status, "published"
    assert_equal @reference.status, "in-press"
  end

  def test_languages_methods
    assert_equal @reference.languages, []

    @reference.languages << "eng"
    assert_equal @reference.languages, []

    @reference.add_language "english"
    assert_equal @reference.languages, ["eng"]
    @reference.add_language "GER"
    assert_equal @reference.languages, ["eng", "deu"]
    @reference.add_language "en"
    assert_equal @reference.languages, ["eng", "deu"]

    @reference.reset_languages
    assert_equal @reference.languages, []

    @reference.add_language "Inglish"
    assert_equal @reference.languages, []
  end

  def test_languages_output_correctly
    %w(en GER french Inglish).each do |lang|
      @reference.add_language lang
    end
    y = @reference.fields.to_yaml
    assert y.include? "languages:\n- eng\n- deu\n- fra\n"

    @reference.reset_languages
    y = @reference.fields.to_yaml
    refute y.include? "languages:\n"
  end

  def test_license_is_set_and_output_correctly
    assert_equal @reference.license, ""

    @reference.license = "Bad Licence"
    assert_equal @reference.license, ""

    @reference.license = "Apache-2.0"
    assert_equal @reference.license, "Apache-2.0"

    @reference.license = "Bad Licence"
    assert_equal @reference.license, "Apache-2.0"

    y = @reference.fields.to_yaml
    assert y.include? "license: Apache-2.0\n"
  end

  def test_bad_dates_raises_error
    [
      'date_accessed',
      'date_downloaded',
      'date_published',
      'date_released'
    ].each do |method|
      exp = assert_raises(ArgumentError) do
        @reference.send("#{method}=", 'nonsense')
      end
      assert exp.message.include?('invalid date')
    end
  end

  def test_dates_are_set_and_output_correctly
    [
      'date_accessed',
      'date_downloaded',
      'date_published',
      'date_released'
    ].each do |method|
      date = Date.today
      @reference.send("#{method}=", date)
      assert_equal @reference.send(method), date
      y = @reference.fields.to_yaml
      assert y.include? "#{method_to_field(method)}: #{date.iso8601}"

      date = "1999-12-31"
      @reference.send("#{method}=", date)
      assert_equal @reference.send(method), Date.parse(date)
      y = @reference.fields.to_yaml
      assert y.include? "#{method_to_field(method)}: #{date}"
    end
  end

  def test_simple_fields_set_and_output_correctly
    value = "a simple string field"
    methods = [
      'abbreviation',
      'abstract',
      'collection_doi',
      'collection_title',
      'collection_type',
      'commit',
      'copyright',
      'data_type',
      'database',
      'department',
      'doi',
      'edition',
      'entry',
      'filename',
      'format',
      'isbn',
      'issn',
      'issue_date',
      'issue_title',
      'journal',
      'license_url',
      'medium',
      'nihmsid',
      'notes',
      'number',
      'pmcid',
      'repository',
      'repository_code',
      'repository_artifact',
      'scope',
      'section',
      'thesis_type',
      'url',
      'version',
      'volume_title'
    ]

    methods.each do |method|
      assert_equal @reference.send(method), ""
      @reference.send("#{method}=", value)
      assert_equal @reference.send(method), value
    end

    y = @reference.fields.to_yaml

    methods.each do |method|
      assert y.include? "#{method_to_field(method)}: #{value}\n"
    end
  end

  def test_integer_fields_set_and_output_correctly
    value = 42
    methods = [
      'end',
      'issue',
      'loc-end',
      'loc-start',
      'month',
      'number-volumes',
      'pages',
      'start',
      'volume',
      'year',
      'year_original'
    ]

    methods.each do |method|
      assert_equal @reference.send(method), ""
      @reference.send("#{method}=", value)
      assert_equal @reference.send(method), value
    end

    y = @reference.fields.to_yaml

    methods.each do |method|
      assert y.include? "#{method_to_field(method)}: #{value}\n"
    end
  end

  def test_entity_fields_set_and_output_correctly
    methods = [
      'conference',
      'database_provider',
      'institution',
      'location',
      'publisher'
    ]

    methods.each do |method|
      value = ::CFF::Entity.new('Company')
      assert_equal @reference.send(method), ""
      @reference.send("#{method}=", value)
      assert_equal @reference.send(method), value
    end

    y = @reference.fields.to_yaml

    methods.each do |method|
      assert y.include? "#{method_to_field(method)}:\n  name: Company\n"
    end
  end
end
