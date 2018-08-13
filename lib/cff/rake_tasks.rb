# frozen_string_literal: true

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

require 'rake'
require 'rake/tasklib'

##
module CFF

  # Provides rake tasks for helping to maintain CFF files.
  #
  # require 'cff/rake_tasks'
  # CFF::RakeTask.new
  class RakeTask < Rake::TaskLib

    DEFAULT_NAMESPACE = :cff # :nodoc:

    attr_accessor :name
    attr_accessor :verbose

    def initialize(name = DEFAULT_NAMESPACE, *args, &task_block)
      @name = name
      @verbose = false

      yield self if block_given?

      generate_task(*args, &task_block)
    end

    def generate_task(*args, &task_block)
      namespace(name) do
        desc 'A description'
        task(:generate, *args) do |_, task_args|
          RakeFileUtils.verbose(verbose) do
            yield(*[self, task_args].slice(0, task_block.arity)) if block_given?
            generate
          end
        end
      end
    end

    private

    def generate
      puts 'Generating CFF file...' if verbose
    end
  end
end
