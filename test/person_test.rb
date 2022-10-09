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

require 'yaml'
require 'cff/person'

class CFFPersonTest < Minitest::Test
  include TestUtil

  def setup
    @person = ::CFF::Person.new('Rob', 'Haines')
  end

  def test_bad_methods_not_allowed
    refute_respond_to(@person, :aaaaaaa)
    assert_raises(NoMethodError) do
      @person.aaaaaaa
    end

    refute_respond_to(@person, :Affiliation)
    assert_raises(NoMethodError) do
      @person.Affiliation = 'Company'
    end
  end

  def test_simple_fields_set_and_output_correctly
    data = [
      ['address', 'A street'],
      ['affiliation', 'A University'],
      ['alias', 'A Pseudonym'],
      ['city', 'Manchester'],
      ['country', 'GB'],
      ['email', 'email@example.org'],
      ['name-particle', 'van der'],
      ['name-suffix', 'III'],
      ['orcid', 'https://orcid.org/0000-0001-2345-6789'],
      ['post-code', 'M13 9PL'],
      ['region', 'Greater Manchester'],
      ['website', 'https://home.example.org']
    ]

    data.each do |method, value|
      assert_equal('', @person.send(method))
      @person.send("#{method}=", value)
      assert_equal(value, @person.send(method))
    end

    y = @person.fields.to_yaml

    data.each do |method, value|
      assert_includes(y, "#{method_to_field(method)}: #{value}\n")
    end
  end

  def test_tel_fax_fields_set_and_output_correctly
    number = '+44 (0) 161-234-5678'
    @person.fax = number
    @person.tel = number

    assert_equal(number, @person.fax)
    assert_equal(number, @person.tel)

    y = @person.fields.to_yaml

    assert_includes(y, "fax: \"#{number}\"\n")
    assert_includes(y, "tel: \"#{number}\"\n")
  end

  def test_new_with_block
    person = ::CFF::Person.new('Rob', 'Haines') do |p|
      assert_equal('Rob', p.given_names)
      assert_equal('Haines', p.family_names)
      p.email = 'email@example.org'
    end

    assert_equal('Rob', person.given_names)
    assert_equal('Haines', person.family_names)
    assert_equal('email@example.org', person.email)
    assert person.is_a?(::CFF::Person)
  end

  def test_new_no_params
    person = ::CFF::Person.new
    assert_empty(person.given_names)
    assert_empty(person.family_names)
  end

  def test_new_no_params_with_block
    person = ::CFF::Person.new do |p|
      assert_empty(p.given_names)
      assert_empty(p.family_names)
      p.alias = 'E.T.'
    end

    assert_equal('E.T.', person.alias)
  end

  def test_empty?
    refute_empty(@person)
  end
end
