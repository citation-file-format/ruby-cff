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
  class File

    YAML_HEADER = "---\n"

    def initialize(param)
      unless Model === param
        param = Model.new(param)
      end

      @model = param
    end

    def self.read(file)
      new(YAML::load_file(file))
    end

    def self.write(file, cff)
      unless String === cff
        cff = cff.to_yaml
      end

      ::File.write(file, cff[YAML_HEADER.length...-1])
    end

    def method_missing(name, *args)
      super unless Model::ALLOWED_METHODS.include?(name)

      @model.send name, args
    end

  end
end
