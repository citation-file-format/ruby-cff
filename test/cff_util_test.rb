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

class CFFUtilTest < Minitest::Test
  include ::CFF::Util

  def test_delete_from_hash
    h = {one: 1, two: 2, three: 3}

    r = delete_from_hash(h, :rubbish)
    refute_same r, h
    assert_equal r, h

    r = delete_from_hash(h, :one)
    refute_equal r, h
    assert !r.has_key?(:one)
    assert_equal r.size, 2
    assert_equal h.size, 3
  end
end
