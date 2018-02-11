
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cff/version"

Gem::Specification.new do |spec|
  spec.name          = "cff"
  spec.version       = CFF::VERSION
  spec.authors       = ["Robert Haines"]
  spec.email         = ["robert.haines@manchester.ac.uk"]

  spec.summary       = "A Ruby library for manipulating CITATION.cff files."
  spec.description   = "See https://citation-file-format.github.io/ for more info."
  spec.homepage      = "https://github.com/hainesr/cff-gem"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
