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

require 'test_helper'
require 'cff/rake_tasks'

class CFFRakeTasksTest < Minitest::Test

  def setup
    Rake::Task.clear
  end

  def test_default_rake_tasks_defined
    cff = ::CFF::RakeTask.new

    assert_equal cff.name, :cff
    assert Rake::Task.task_defined?('cff:create')
  end

  def test_named_rake_tasks_defined
    cff = ::CFF::RakeTask.new do |task|
      task.name = :cite
    end

    assert_equal cff.name, :cite
    assert Rake::Task.task_defined?('cite:create')
  end

  def test_rake_tasks_default_options
    cff = ::CFF::RakeTask.new

    refute cff.verbose
  end

  def test_rake_tasks_options
    cff = ::CFF::RakeTask.new do |task|
      task.verbose = true
    end

    assert cff.verbose
  end

  def test_running_create_rake_task_verbose
    ::CFF::RakeTask.new do |task|
      task.verbose = true
    end

    out, err = capture_io do
      Rake::Task['cff:create'].execute
    end

    refute_empty out
    assert_empty err
  end
end
