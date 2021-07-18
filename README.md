# Ruby CFF
## Robert Haines and The Ruby Citation File Format Developers

A Ruby library for creating, editing, validating and converting CITATION.cff files.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1184077.svg)](https://doi.org/10.5281/zenodo.1184077)
[![Gem Version](https://badge.fury.io/rb/cff.svg)](https://badge.fury.io/rb/cff)
[![Tests](https://github.com/citation-file-format/ruby-cff/actions/workflows/ruby.yml/badge.svg)](https://github.com/citation-file-format/ruby-cff/actions/workflows/ruby.yml)
[![Linter](https://github.com/citation-file-format/ruby-cff/actions/workflows/lint.yml/badge.svg)](https://github.com/citation-file-format/ruby-cff/actions/workflows/lint.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/6bb4c661bfb4971260ba/maintainability)](https://codeclimate.com/github/citation-file-format/ruby-cff/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/citation-file-format/ruby-cff/badge.svg)](https://coveralls.io/github/citation-file-format/ruby-cff)

### Synopsis

This library provides a Ruby interface to create and edit Citation File Format (CFF) files. The resulting files can be validated against a formal schema to ensure correctness and can be output in a number of different citation-friendly formats.

The primary API entry points are the `Model` and `File` classes.

See the [CITATION.cff documentation](https://citation-file-format.github.io/) for more details about the Citation File Format.

See the [full API documentation](https://citation-file-format.github.io/ruby-cff/) for more details about Ruby CFF.

### Quick start

You can quickly build and save a CFF model like this:

```ruby
model = CFF::Model.new('Ruby CFF Library') do |cff|
  cff.version = CFF::VERSION
  cff.date_released = Date.today
  cff.authors << CFF::Person.new('Robert', 'Haines')
  cff.license = 'Apache-2.0'
  cff.keywords << 'ruby' << 'credit' << 'citation'
  cff.repository_artifact = 'https://rubygems.org/gems/cff'
end

CFF::File.write('CITATION.cff', model)
```

Which will produce a file that looks something like this:

```yaml
cff-version: 1.2.0
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
  cff.authors << CFF::Person.new('Robert', 'Haines')
  cff.license = 'Apache-2.0'
  cff.keywords << 'ruby' << 'credit' << 'citation'
  cff.repository_artifact = 'https://rubygems.org/gems/cff'
end
```

### Validating CFF files

To quickly validate a file and raise an error on failure, you can use `CFF::File` directly:

```ruby
begin
  CFF::File.validate!('CITATION.cff')
rescue CFF::ValidationError => e
  # Handle validation errors here...
end
```

Both `CFF::File` and `CFF::Model` have instance methods to validate CFF files as well:

```ruby
cff = CFF::File.read('CITATION.cff')
begin
  cff.validate!(fail_fast: true)
rescue CFF::ValidationError => e
  # Handle validation errors here...
end
```

Non-bang methods (`validate`) return a two-element array, with `true`/`false` at index 0 to indicate pass/fail, and an array of errors at index 1 (if any).

Passing `fail_fast: true` (default: `false`) will cause the validator to abort on the first error it encounters and report just that. Only the instance methods on `CFF::File` and `CFF::Model` provide the `fail_fast` option.

### Library versions

Until this library reaches version 1.0.0 the API may be subject to breaking changes. When version 1.0.0 is released, then the principles of [semantic versioning](https://semver.org/) will be applied.

### Licence

[Apache 2.0](http://www.apache.org/licenses/). See LICENCE for details.

### Research notice

Please note that this repository is participating in a study into sustainability
 of open source projects. Data will be gathered about this repository for
 approximately the next 12 months, starting from June 2021.

Data collected will include number of contributors, number of PRs, time taken to
 close/merge these PRs, and issues closed.

For more information, please visit
[our informational page](https://sustainable-open-science-and-software.github.io/) or download our [participant information sheet](https://sustainable-open-science-and-software.github.io/assets/PIS_sustainable_software.pdf).
