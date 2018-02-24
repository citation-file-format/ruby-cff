# Ruby CFF
## Robert Haines

A Ruby library for manipulating CITATION.cff files.

[![Gem Version](https://badge.fury.io/rb/cff.svg)](https://badge.fury.io/rb/cff)
[![Build Status](https://travis-ci.org/hainesr/ruby-cff.svg?branch=master)](https://travis-ci.org/hainesr/ruby-cff)
[![Maintainability](https://api.codeclimate.com/v1/badges/7eaa3890f17664e10bc6/maintainability)](https://codeclimate.com/github/hainesr/ruby-cff/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/hainesr/ruby-cff/badge.svg)](https://coveralls.io/github/hainesr/ruby-cff)

### Synopsis

This library provides a Ruby interface to manipulate CITATION.cff files. The primary entry points are the Model and File classes.

See the [CITATION.cff documentation](https://citation-file-format.github.io/) for more details.

### Quick start

```ruby
cff = CFF::Model.new("Ruby CFF Library")
cff.version = "0.1.0"
cff.date_released = Date.today
cff.authors << CFF::Person.new("Robert", "Haines")

CFF::File.write("CITATION.cff", cff)
```

Will produce a file that looks something like this:

```
cff-version: 1.0.3
message: If you use this software in your work, please cite it using the following metadata
title: Ruby CFF Library
version: 0.1.0
date-released: 2018-02-18
authors:
- family-names: Haines
  given-names: Robert
```

### Licence

[Apache 2.0](http://www.apache.org/licenses/). See LICENCE for details.
