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

module CFF
  class Model

    DEFAULT_MESSAGE = "If you use this software in your work, please cite it using the following metadata"

    def initialize(param)
      if Hash === param
        @fields = param
      else
        @fields = Hash.new('')
        @fields['cff-version'] = DEFAULT_SPEC_VERSION
        @fields['message'] = DEFAULT_MESSAGE
        @fields['title'] = param
      end
    end

    def date_released=(date)
      unless Date === date
        date = Date.parse(date)
      end

      @fields['date-released'] = date
    end

    def version=(version)
      @fields['version'] = version.to_s
    end

    def to_yaml
      YAML.dump @fields, :line_width => -1, :indentation => 2
    end

    def method_missing(name, *args)
      n = method_to_field(name.id2name)
      if n.end_with?('=')
        @fields[n.chomp('=')] = args[0] || ''
      else
        @fields[n]
      end
    end

    private

    def method_to_field(name)
      name.gsub('_', '-')
    end

  end
end
