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

    attr_reader :cff_version
    attr_reader :date_released
    attr_accessor :message
    attr_accessor :title
    attr_reader :version

    def initialize(title)
      @cff_version = DEFAULT_SPEC_VERSION
      @title = title
      @message = DEFAULT_MESSAGE
    end

    def date_released=(date)
      unless date.kind_of? Date
        date = Date.parse(date)
      end

      @date_released = date
    end

    def version=(version)
      @version = version.to_s
    end

    def encode_with(coder)
      coder["cff-version"] = @cff_version
      coder["date-released"] = @date_released || ""
      coder["message"] = @message || ""
      coder["title"] = @title || ""
      coder["version"] = @version || ""
    end

    def init_with(coder)
      @cff_version = coder["cff-version"]
      self.date_released = coder["date-released"]
      @message = coder["message"]
      @title = coder["title"]
      self.version = coder["version"]
    end

    def to_yaml
      YAML.dump self, :line_width => -1
    end

  end
end
