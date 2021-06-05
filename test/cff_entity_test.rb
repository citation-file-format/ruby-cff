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

class CFFEntityTest < Minitest::Test

  include ::CFF::Util

  def setup
    @entity = ::CFF::Entity.new('Some Company')
  end

  def test_bad_methods_not_allowed
    refute @entity.respond_to?(:aaaaaaa)
    assert_raises(NoMethodError) do
      @entity.aaaaaaa
    end

    refute @entity.respond_to?(:Address)
    assert_raises(NoMethodError) do
      @entity.Address = 'A Street'
    end
  end

  def test_simple_fields_set_and_output_correctly
    data = [
      ['address', 'A Street'],
      ['city', 'Manchester'],
      ['country', 'GB'],
      ['email', 'email@example.org'],
      ['location', 'Classified'],
      ['orcid', 'https://orcid.org/0000-0001-2345-6789'],
      ['post-code', 'M13 9PL'],
      ['region', 'Greater Manchester'],
      ['website', 'https://home.example.org']
    ]

    data.each do |method, value|
      assert_equal @entity.send(method), ''
      @entity.send("#{method}=", value)
      assert_equal @entity.send(method), value
    end

    y = @entity.fields.to_yaml

    data.each do |method, value|
      assert y.include? "#{method_to_field(method)}: #{value}\n"
    end
  end

  def test_date_fields_set_and_output_correctly
    date = Date.today
    @entity.date_end = date
    @entity.date_start = date

    assert_equal @entity.date_end, date
    assert_equal @entity.date_start, date

    y = @entity.fields.to_yaml

    assert y.include? "date-end: #{date}\n"
    assert y.include? "date-start: #{date}\n"
  end

  def test_date_fields_set_and_output_correctly_with_text
    date = '1999-12-31'
    @entity.date_end = date
    @entity.date_start = date

    assert_equal @entity.date_end, Date.parse(date)
    assert_equal @entity.date_start, Date.parse(date)

    y = @entity.fields.to_yaml

    assert y.include? "date-end: #{date}\n"
    assert y.include? "date-start: #{date}\n"
  end

  def test_tel_fax_fields_set_and_output_correctly
    number = '+44 (0) 161-234-5678'
    @entity.fax = number
    @entity.tel = number

    assert_equal @entity.fax, number
    assert_equal @entity.tel, number

    y = @entity.fields.to_yaml

    assert y.include? "fax: \"#{number}\"\n"
    assert y.include? "tel: \"#{number}\"\n"
  end

  def test_new_with_block
    entity = ::CFF::Entity.new('My Company') do |e|
      assert_equal e.name, 'My Company'
      e.tel = '+44 (0) 161-234-5678'
    end

    assert_equal entity.name, 'My Company'
    assert_equal entity.tel, '+44 (0) 161-234-5678'
    assert entity.is_a?(::CFF::Entity)
  end
end
