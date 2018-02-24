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

class CFFPersonTest < Minitest::Test
  include ::CFF::Util

  def setup
    @person = ::CFF::Person.new("Rob", "Haines")
  end

  def test_bad_methods_not_allowed
    assert_raises(NoMethodError) do
      @person.aaaaaaa
    end

    assert_raises(NoMethodError) do
      @person.Affiliation = "Company"
    end
  end

  def test_simple_fields_set_and_output_correctly
    data = [
      ["affiliation", "A University"]
    ]

    data.each do |method, value|
      assert_equal @person.send(method), ""
      @person.send("#{method}=", value)
      assert_equal @person.send(method), value
    end

    y = @person.fields.to_yaml

    data.each do |method, value|
      assert y.include? "#{method_to_field(method)}: #{value}\n"
    end
  end
end
