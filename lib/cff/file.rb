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

#
module CFF

  # File provides direct access to a CFF Model, with the addition of some
  # filesystem utilities.
  class File

    YAML_HEADER = "---\n".freeze # :nodoc:

    # :call-seq:
    #   new(title) -> File
    #   new(model) -> File
    #
    # Create a new File. Either a pre-existing Model can be passed in or, as
    # with Model itself, a title can be supplied to initalize a new File.
    #
    # All methods provided by Model are also available directly on File
    # objects.
    def initialize(param)
      unless param.is_a?(Model)
        param = Model.new(param)
      end

      @model = param
    end

    # :call-seq:
    #   read(file) -> File
    #
    # Read a file and parse it for subsequent manipulation.
    def self.read(file)
      new(YAML.load_file(file))
    end

    # :call-seq:
    #   write(file, model)
    #   write(file, yaml)
    #
    # Write the supplied model or yaml string to `file`.
    def self.write(file, cff)
      unless cff.is_a?(String)
        cff = cff.to_yaml
      end

      ::File.write(file, cff[YAML_HEADER.length...-1])
    end

    def method_missing(name, *args) # :nodoc:
      @model.respond_to?(name) ? @model.send(name, *args) : super
    end

    def respond_to_missing?(name, *all) # :nodoc:
      @model.respond_to?(name, *all)
    end
  end
end
