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

require 'simplecov'

$LOAD_PATH.unshift ::File.expand_path('../lib', __dir__)
require 'cff'

require 'test_construct'
require 'minitest/autorun'

FILES_DIR = ::File.expand_path('files', __dir__)
OUT_FILES_DIR = ::File.join(FILES_DIR, 'out')
COMPLETE_CFF = ::File.join(FILES_DIR, 'complete.cff')
SHORT_CFF = ::File.join(FILES_DIR, 'short.cff')
MINIMAL_CFF = ::File.join(FILES_DIR, 'minimal.cff')
INCOMPLETE_CFF = ::File.join(FILES_DIR, 'bad', 'incomplete.cff')
OUTPUT_CFF = 'CITATION.cff'

CONVERTED_DIR = ::File.expand_path('converted', __dir__)

CONSTRUCT_OPTS = {
  keep_on_error: true
}.freeze
