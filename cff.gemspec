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

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cff/version"

Gem::Specification.new do |spec|
  spec.name          = "cff"
  spec.version       = CFF::VERSION
  spec.authors       = ["Robert Haines"]
  spec.email         = ["robert.haines@manchester.ac.uk"]

  spec.summary       = "A Ruby library for manipulating CITATION.cff files."
  spec.description   = "See https://citation-file-format.github.io/ for more info."
  spec.homepage      = "https://github.com/citation-file-format/ruby-cff"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.0"

  spec.add_runtime_dependency "language_list", "~> 1.2"
  spec.add_runtime_dependency "spdx-licenses", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rdoc", "~> 6.0"
  spec.add_development_dependency "rubocop", "~> 0.54"
  spec.add_development_dependency "test_construct", "~> 2.0"
end
