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

require 'forwardable'

module CFF
  class File
    extend Forwardable

    def_delegators :@model, :cff_version, :message, :message=, :title

    YAML_HEADER = "--- !ruby/object:CFF::Model\n"

    def initialize(cff)
      @model = cff
    end

    def self.read(file)
      cff = ::File.read(file)
      new(YAML::load(YAML_HEADER + cff))
    end

    def self.write(file, cff)
      ::File.write(file, cff[YAML_HEADER.length...-1])
    end

  end
end
