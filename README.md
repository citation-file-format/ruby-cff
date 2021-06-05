# Ruby CFF
## Robert Haines

A Ruby library for manipulating CITATION.cff files.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1184077.svg)](https://doi.org/10.5281/zenodo.1184077)
[![Gem Version](https://badge.fury.io/rb/cff.svg)](https://badge.fury.io/rb/cff)
[![Tests](https://github.com/citation-file-format/ruby-cff/actions/workflows/ruby.yml/badge.svg)](https://github.com/citation-file-format/ruby-cff/actions/workflows/ruby.yml)
[![Linter](https://github.com/citation-file-format/ruby-cff/actions/workflows/lint.yml/badge.svg)](https://github.com/citation-file-format/ruby-cff/actions/workflows/lint.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/6bb4c661bfb4971260ba/maintainability)](https://codeclimate.com/github/citation-file-format/ruby-cff/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/citation-file-format/ruby-cff/badge.svg)](https://coveralls.io/github/citation-file-format/ruby-cff)

### Synopsis

This library provides a Ruby interface to manipulate CITATION.cff files. The primary entry points are the Model and File classes.

See the [CITATION.cff documentation](https://citation-file-format.github.io/) for more details.

### Quick start

You can quickly build and save a CFF model like this:

```ruby
model = CFF::Model.new("Ruby CFF Library") do |cff|
  cff.version = CFF::VERSION
  cff.date_released = Date.today
  cff.authors << CFF::Person.new("Robert", "Haines")
  cff.license = "Apache-2.0"
  cff.keywords << "ruby" << "credit" << "citation"
  cff.repository_artifact = "https://rubygems.org/gems/cff"
end

CFF::File.write("CITATION.cff", model)
```

Which will produce a file that looks something like this:

```yaml
cff-version: 1.0.3
message: If you use this software in your work, please cite it using the following metadata
title: Ruby CFF Library
authors:
- family-names: Haines
  given-names: Robert
keywords:
- ruby
- credit
- citation
version: 0.6.0
date-released: 2021-06-05
license: Apache-2.0
repository-artifact: https://rubygems.org/gems/cff
```

`CFF::File` can be used to create a file directly, and it exposes the underlying `CFF::Model` directly. If using a block with `CFF::File::open` the file will get written on closing it:

```ruby
CFF::File.open('CITATION.cff') do |cff|
  cff.version = CFF::VERSION
  cff.date_released = Date.today
  cff.authors << CFF::Person.new("Robert", "Haines")
  cff.license = "Apache-2.0"
  cff.keywords << "ruby" << "credit" << "citation"
  cff.repository_artifact = "https://rubygems.org/gems/cff"
end
```

### Library versions

Until this library reaches version 1.0.0 the API may be subject to breaking changes. When version 1.0.0 is released, then the principles of [semantic versioning](https://semver.org/) will be applied.

### Licence

[Apache 2.0](http://www.apache.org/licenses/). See LICENCE for details.
