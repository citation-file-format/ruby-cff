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

    DEFAULT_MESSAGE = "If you use #TITLE# in your work, please cite it using the following metadata"

    attr_reader :cff_version
    attr_reader :message
    attr_reader :title

    def initialize(title)
      @cff_version = DEFAULT_SPEC_VERSION
      @title = title
      @message = DEFAULT_MESSAGE.gsub('#TITLE#', title)
    end

    def message=(message)
      @message = message.nil? ? "" : message
    end

    def encode_with(coder)
      coder["cff-version"] = @cff_version
      coder["message"] = @message
      coder["title"] = @title
    end

    def init_with(coder)
      @cff_version = coder["cff-version"]
      @message = coder["message"]
      @title = coder["title"]
    end

  end
end
