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

require_relative '../test_helper'

require 'cff/formatters/formatter'
require 'cff/index'

class CFFFormatterTest < Minitest::Test
  def test_month_and_year_from_date
    [nil, '', ' ', 'nil'].each do |date|
      assert_equal(['', ''], CFF::Formatters::Formatter.month_and_year_from_date(date))
    end

    date_str = '2021-08-05'
    date = Date.parse(date_str)
    assert_equal(
      ['8', '2021'], CFF::Formatters::Formatter.month_and_year_from_date(date_str)
    )
    assert_equal(
      ['8', '2021'], CFF::Formatters::Formatter.month_and_year_from_date(date)
    )
  end

  def test_month_and_year_from_model
    date = Date.parse('2021-08-05')

    model = ::CFF::Index.new('Title')
    model.date_released = date
    assert_equal(
      ['8', '2021'], CFF::Formatters::Formatter.month_and_year_from_model(model)
    )

    ref = ::CFF::Reference.new('Title')
    ref.date_released = date
    assert_equal(
      ['8', '2021'], CFF::Formatters::Formatter.month_and_year_from_model(ref)
    )

    ref = ::CFF::Reference.new('Title')
    ref.month = 9
    ref.year = 2020
    assert_equal(
      ['9', '2020'], CFF::Formatters::Formatter.month_and_year_from_model(ref)
    )

    # No dates.
    ref = ::CFF::Reference.new('Title')
    assert_equal(
      ['', ''], CFF::Formatters::Formatter.month_and_year_from_model(ref)
    )

    # Ignore date_released if month and year set.
    ref = ::CFF::Reference.new('Title')
    ref.month = 9
    ref.year = 2020
    ref.date_released = date
    assert_equal(
      ['9', '2020'], CFF::Formatters::Formatter.month_and_year_from_model(ref)
    )

    # Year missing, fall back to date_released.
    ref = ::CFF::Reference.new('Title')
    ref.month = 9
    ref.date_released = date
    assert_equal(
      ['8', '2021'], CFF::Formatters::Formatter.month_and_year_from_model(ref)
    )
  end
end
