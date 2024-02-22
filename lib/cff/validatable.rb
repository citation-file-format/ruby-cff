# frozen_string_literal: true

# Copyright (c) 2018-2024 The Ruby Citation File Format Developers.
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

require_relative 'errors'
require_relative 'schemas'

require 'json_schema'

##
module CFF
  # Methods to validate CFF files/models against a formal schema.
  module Validatable
    SCHEMAS = Schemas::VERSIONS.to_h do |version|
      schema = JsonSchema.parse!(Schemas::FILES[version])
      schema.expand_references!

      [version, schema]
    end.freeze # :nodoc:

    # :call-seq:
    #   validate!(fail_fast: false, validate_as: nil)
    #
    # Validate a CFF file or model (Index) and raise a ValidationError upon
    # failure. If an error is raised it will contain the detected validation
    # failures for further inspection.
    #
    # Setting `fail_fast` to true will fail validation at the first detected
    # failure, rather than gathering and returning all failures.
    #
    # Setting `validate_as` to a specific version will validate against that
    # version of the schema, rather than the version specified in the CFF file.
    # If the version specified is not a valid schema version, the version in
    # the CFF file, or the default schema version will be used.
    def validate!(fail_fast: false, validate_as: nil)
      result = validate(fail_fast: fail_fast, validate_as: validate_as)
      return if result[0]

      raise ValidationError.new(result[1])
    end

    # :call-seq:
    #   validate(fail_fast: false, validate_as: nil) -> Array
    #
    # Validate a CFF file or model (Index) and return an array with the result.
    # The result array is a two-element array, with `true`/`false` at index 0
    # to indicate pass/fail, and an array of errors at index 1 (if any).
    #
    # Setting `fail_fast` to true will fail validation at the first detected
    # failure, rather than gathering and returning all failures.
    #
    # Setting `validate_as` to a specific version will validate against that
    # version of the schema, rather than the version specified in the CFF file.
    # If the version specified is not a valid schema version, the version in
    # the CFF file, or the default schema version will be used.
    def validate(fail_fast: false, validate_as: nil)
      schema = Schemas::VERSIONS.include?(validate_as) ? validate_as : @fields['cff-version']
      schema = Schemas::DEFAULT_VERSION if schema.nil? || schema.empty?

      model = fields(validate: true)
      model['cff-version'] = schema unless validate_as.nil?

      SCHEMAS[schema].validate(model, fail_fast: fail_fast)
    end
  end
end
