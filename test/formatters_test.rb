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

require 'cff/formatters'

class CFFFormattersTest < Minitest::Test
  # Fake formatter.
  class TestFormatter
    def self.format; end

    def self.label
      'TestFormatterLabel'
    end
  end

  # Another fake formatter, with the same label.
  class AnotherTestFormatter
    def self.format; end

    def self.label
      'TestFormatterLabel'
    end
  end

  def setup
    CFF::Formatters.register_formatter(TestFormatter)
  end

  def test_register_formatter
    # Check that a new formatter with the same label overrides the incumbent.
    assert(
      CFF::Formatters.instance_variable_get(:@formatters).has_value?(TestFormatter)
    )

    CFF::Formatters.register_formatter(AnotherTestFormatter)

    refute(
      CFF::Formatters.instance_variable_get(:@formatters).has_value?(TestFormatter)
    )
    assert(
      CFF::Formatters.instance_variable_get(:@formatters).has_value?(AnotherTestFormatter)
    )
  end

  def test_register_non_formatter
    CFF::Formatters.register_formatter(String)
    refute(CFF::Formatters.instance_variable_get(:@formatters).has_value?(String))
  end

  def test_formatter_for
    # At this point we don't know which of our two test formatters is
    # registered because test execution order is random.
    refute_nil(CFF::Formatters.formatter_for(:testformatterlabel))

    assert_nil(CFF::Formatters.formatter_for(:bad_test))
  end
end
