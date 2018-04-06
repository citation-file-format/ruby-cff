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

class CFFModelTest < Minitest::Test

  include ::CFF::Util

  def test_bad_methods_not_allowed
    m = ::CFF::Model.new('')

    refute m.respond_to?(:aaaaaaa)
    assert_raises(NoMethodError) do
      m.aaaaaaa
    end

    refute m.respond_to?(:Message)
    assert_raises(NoMethodError) do
      m.Message
    end
  end

  def test_default_model_cff_version
    assert_equal ::CFF::Model.new('').cff_version, ::CFF::DEFAULT_SPEC_VERSION
  end

  def test_cff_version_is_output_correctly
    m = ::CFF::Model.new('').to_yaml
    assert m.include? 'cff-version'
    refute m.include? 'cff_version'
  end

  def test_message_is_output_correctly
    ['', 'aaabbbccc'].each do |title|
      m = ::CFF::Model.new(title).to_yaml
      assert m.include? "message: #{::CFF::Model::DEFAULT_MESSAGE}"
    end
  end

  def test_set_message
    m = ::CFF::Model.new('title')
    m.message = nil
    y = m.to_yaml
    assert y.include? "message: ''"

    m.message = 'this is a message'
    y = m.to_yaml
    assert_equal m.message, 'this is a message'
    assert y.include? 'message: this is a message'
  end

  def test_title_is_output_correctly
    ['', 'aaabbbccc'].each do |title|
      m = ::CFF::Model.new(title).to_yaml
      assert m.include? "title: #{title}"
    end
  end

  def test_set_title
    title = 'software title'
    m = ::CFF::Model.new(title)
    assert_equal m.title, title

    title = 'new title'
    m.title = title
    y = m.to_yaml
    assert_equal m.title, title
    assert y.include? "title: #{title}"
  end

  def test_version_is_set_and_output_correctly
    m = ::CFF::Model.new('title')
    [1.0, '1.0.0'].each do |version|
      m.version = version
      assert_equal m.version, version.to_s

      y = m.to_yaml
      assert y.include? "version: #{version}"
    end
  end

  def test_bad_date_released_raises_error
    m = ::CFF::Model.new('title')

    exp = assert_raises(ArgumentError) do
      m.date_released = 'nonsense'
    end
    assert exp.message.include?('invalid date')
  end

  def test_date_released_is_set_and_output_correctly
    m = ::CFF::Model.new('title')

    date = Date.today
    m.date_released = date
    assert_equal m.date_released, date
    y = m.to_yaml
    assert y.include? "date-released: #{date.iso8601}"

    date = '1999-12-31'
    m.date_released = date
    assert_equal m.date_released, Date.parse(date)
    y = m.to_yaml
    assert y.include? "date-released: #{date}"
  end

  def test_authors_set_and_output_correctly
    m = ::CFF::Model.new('title')
    a = ::CFF::Person.new('First', 'Second')
    e = ::CFF::Entity.new('Company')
    r = [::CFF::Person.new('F', 'S'), '_ _ _', ::CFF::Entity.new('Co.')]

    m.authors << a
    m.authors << '_ _ _'
    m.authors << e

    y = m.to_yaml
    assert_equal m.authors.length, 2
    assert y.include? "authors:\n- family-names: Second\n  given-names: First\n- name: Company"
    refute y.include? '_ _ _'

    m.authors = r

    y = m.to_yaml
    assert_equal m.authors.length, 2
    assert y.include? "authors:\n- family-names: S\n  given-names: F\n- name: Co."
    refute y.include? '_ _ _'
  end

  def test_simple_fields_set_and_output_correctly
    m = ::CFF::Model.new('title')

    data = [
      ['abstract', 'An abstract'],
      ['commit', 'dce4a2de56c589b55c13249c49a81924ead238b9'],
      ['doi', '10.5281/zenodo.1003150'],
      ['license', 'Apache-2.0'],
      ['license_url', 'http://example.org/licence.txt'],
      ['repository', 'http://example.org/repo/cff'],
      ['repository_artifact', 'http://example.org/repo/cff/package'],
      ['repository_code', 'http://example.org/repo/cff/code'],
      ['url', 'http://userid:password@example.com:8080/']
    ]

    data.each do |method, value|
      assert_equal m.send(method), ''
      m.send("#{method}=", value)
      assert_equal m.send(method), value
    end

    y = m.to_yaml

    data.each do |method, value|
      assert y.include? "#{method_to_field(method)}: #{value}\n"
    end
  end

  def test_contact_set_and_output_correctly
    m = ::CFF::Model.new('title')
    a = ::CFF::Person.new('First', 'Second')
    e = ::CFF::Entity.new('Company')
    r = [::CFF::Person.new('F', 'S'), '_ _ _', ::CFF::Entity.new('Co.')]

    m.contact << a
    m.contact << '_ _ _'
    m.contact << e

    y = m.to_yaml
    assert_equal m.contact.length, 2
    assert y.include? "contact:\n- family-names: Second\n  given-names: First\n- name: Company"
    refute y.include? '_ _ _'

    m.contact = r

    y = m.to_yaml
    assert_equal m.contact.length, 2
    assert y.include? "contact:\n- family-names: S\n  given-names: F\n- name: Co."
    refute y.include? '_ _ _'
  end

  def test_keywords_set_and_output_correctly
    m = ::CFF::Model.new('title')
    keys = ['one', :two, 3]

    y = m.to_yaml
    refute y.include? 'keywords:'

    m.keywords = keys
    l = keys.length
    assert_equal m.keywords.length, l

    m.keywords << 'four'
    l += 1
    assert_equal m.keywords.length, l

    y = m.to_yaml
    assert_equal m.keywords.length, l
    assert y.include? "keywords:\n- one\n- two\n- '3'\n- four\n"
  end

  def test_references_set_and_output_correctly
    m = ::CFF::Model.new('title')
    a = ::CFF::Person.new('First', 'Second')
    e = ::CFF::Entity.new('Company')
    r = ::CFF::Reference.new('book title', 'book')
    r.authors << a
    r.authors << '_ _ _'
    r.authors << e

    m.references << r
    m.references << '_ _ _'
    assert_equal m.references.length, 2
    assert_equal m.references[0].authors.length, 3

    y = m.to_yaml
    assert_equal m.references.length, 1
    assert_equal m.references[0].authors.length, 2
    assert y.include? "references:\n- type: book\n  title: book title\n"
    assert y.include? "  authors:\n  - family-names: Second\n    given-names: First\n  - name: Company\n"
    refute y.include? '_ _ _'
  end

  def test_empty_collections_are_not_output
    m = ::CFF::Model.new('title')
    y = m.to_yaml

    refute y.include? 'authors:'
    refute y.include? 'contact:'
    refute y.include? 'keywords:'
    refute y.include? 'references:'
  end
end
