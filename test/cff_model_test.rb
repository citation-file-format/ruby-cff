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

class CFFModelTest < Minitest::Test
  def test_bad_methods_not_allowed
    m = ::CFF::Model.new("")

    assert_raises(NoMethodError) do
      m.aaaaaaa
    end

    assert_raises(NoMethodError) do
      m.Message
    end
  end

  def test_default_model_cff_version
    assert_equal ::CFF::Model.new("").cff_version, ::CFF::DEFAULT_SPEC_VERSION
  end

  def test_cff_version_is_output_correctly
    m = ::CFF::Model.new("").to_yaml
    assert m.include? "cff-version"
    refute m.include? "cff_version"
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
      assert_equal m.version, "#{version}"

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

    date = "1999-12-31"
    m.date_released = date
    assert_equal m.date_released, Date.parse(date)
    y = m.to_yaml
    assert y.include? "date-released: #{date}"
  end

  def test_authors_set_and_output_correctly
    m = ::CFF::Model.new('title')
    a = ::CFF::Person.new('First', 'Second')
    e = ::CFF::Entity.new('Company')
    m.authors << a
    m.authors << "_ _ _"
    m.authors << e
    assert_equal m.authors.length, 3

    y = m.to_yaml
    assert_equal m.authors.length, 3
    assert y.include? "authors:\n- family-names: Second\n  given-names: First\n- name: Company"
    refute y.include? "_ _ _"
  end

  def test_simple_fields_set_and_output_correctly
    m = ::CFF::Model.new('title')
    a = "An abstract"
    c = "dce482de56c589b55c13349c49a81924ead238ba"
    d = "10.5281/zenodo.1003150"
    l = "Apache-2.0"
    assert_equal m.abstract, ''
    assert_equal m.commit, ''
    assert_equal m.doi, ''
    assert_equal m.license, ''

    m.abstract = a
    m.commit = c
    m.doi = d
    m.license = l
    assert_equal m.abstract, a
    assert_equal m.commit, c
    assert_equal m.doi, d
    assert_equal m.license, l

    y = m.to_yaml
    assert y.include? "abstract: #{a}\n"
    assert y.include? "commit: #{c}\n"
    assert y.include? "doi: #{d}\n"
    assert y.include? "license: #{l}\n"
  end

  def test_contact_set_and_output_correctly
    m = ::CFF::Model.new('title')
    a = ::CFF::Person.new('First', 'Second')
    e = ::CFF::Entity.new('Company')
    m.contact << a
    m.contact << "_ _ _"
    m.contact << e
    assert_equal m.contact.length, 3

    y = m.to_yaml
    assert_equal m.contact.length, 3
    assert y.include? "contact:\n- family-names: Second\n  given-names: First\n- name: Company"
    refute y.include? "_ _ _"
  end

  def test_keywords_set_and_output_correctly
    m = ::CFF::Model.new('title')
    ks = ["one", :two, 3]
    l = 0

    ks.each do |k|
      m.keywords << k
      l += 1
      assert_equal m.keywords.length, l
    end

    y = m.to_yaml
    assert_equal m.keywords.length, l
    assert y.include? "keywords:\n- one\n- two\n- '3'\n"
  end

  def test_empty_collections_are_not_output
    m = ::CFF::Model.new('title')
    y = m.to_yaml

    refute y.include? "authors: []\n"
    refute y.include? "contact: []\n"
    refute y.include? "keywords: []\n"
  end
end
