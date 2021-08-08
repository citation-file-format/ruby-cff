# Changes log for the Ruby CFF Library

## Version 0.8.0

* Add a comment field to the File class.
* Update the CITATION.cff file to add a comment.
* Document the simple fields in Model.
* Updating Ruby version and dependencies
* GitHub Actions for CI
* Update Gemspec to fix security vulnerabilities
* Implement BibTeX output
* Implement APA-like output
* Update the LICENCE and the file headers.
* Add a linter Action.
* Adjust fixtures to reflect custom styles
* Move latest supported ruby to be >= 2.6.
* Dynamically create tests
* Use the new `YAML.safe_load` API form.
* Add a filename to `CFF::File`.
* Fix invalid references bug
* Allow time to be loaded from YAML
* Add `CFF::File.open` which accepts a block.
* `Model::new` can now accept a block.
* `Entity::new` can now accept a block.
* `Person::new` can now accept a block.
* `Reference::new` can now accept a block.
* Update README with new `Model` and `File` APIs.
* Turn on Actions CI for all branches.
* Turn Coveralls reporting back on after move to Actions.
* Use `Last, First` format for BibTeX output.
* Add `BibtexFormatter::generate_reference`.
* Change DOI links to https in the APA formatter.
* Set up a GitHub Action to build and deploy the docs.
* Add metadata to the gemspec.
* Generalize authorship of the gem a bit.
* Document `to_*` formatting methods in `Model`.
* Add `alias` field to `Person`.
* `Person` no longer requires `given-names` and `family-names`.
* The `version` field can be a number or a string.
* Bump default spec version to 1.2.0.
* Load and parse the CFF schema.
* Add validation code and supporting infrastructure.
* Add validation class methods to `CFF::File`.
* Handle empty fields in `Reference` when reading from files.
* Add an `Identifier` type.
* Add the `identifiers` field to the `Model`.
* Add the `identifiers` field to `Reference`.
* Update the key complete CFF file in the tests.
* Ensure `name-particle` is used in BibTex output.
* Add `preferred-citation` to the `Model`.
* Load the `Entity` fields in a `Reference` correctly.
* Preserve title capitalization in BibTeX output.
* Add `Licensable` mixin.
* Wire `Licensable` into `Model`.
* Wire `Licensable` into `Reference`.
* Use the SPDX licences list in the schema to cross-check.
* Protect `Entity` names in BibTeX output with `{}`.
* Add support for `name-suffix` in BibTeX output.
* Streamline the APA formatter `format_author` method.
* Streamline BibTeX `generate_reference` method.
* Streamline the BibTeX `format_author` method.
* Update `1.2.0` schema.
* Add `Formatter::month_and_year_from_date` util method.
* Add `Formatter::url` util method.
* Simplify `BibtexFormatter::format`.
* Simplify and improve the APA formatter.
* Honour `preferred_citation` when outputting citation text.
* Only use '[Computer software]' label in APA format for software.
* Map `Reference` types to BibTeX types when formatting.

## Version 0.4.0

* Remove unused Util#expand_field method.
* Changed Model#keywords to be a field type.
* Model is now a subclass of ModelPart.
* Document ModelPart and Util just enough.
* Add Util::normalize_modelpart_array! method.
* Tighten up checking for empty collections in model.
* Move the references into the Model fields.
* Add an in-place actor collection builder method.
* Move authors and contact to Model fields.
* Refactor Reference so the actor lists are fields.
* Remove unused method: Util::build_actor_collection.
* Remove unused method: Util::expand_array_field.
* Add rubocop to the development dependencies.
* Add rubocop configuration files.
* Add rubocop rake tasks.
* Many rubocop fixes.
* Compact ALLOWED_FIELDS lists for consistency.
* Allow creation of a Reference without a type.
* Remove unused method: Util.delete_from_hash.
* Refactor duplicated code into Util.fields_to_hash.
* Add File#write (instance method).
* Ensure a model always returns '' for missing fields.
* Test reading short and minimal CFF files.
* Cleanup duplicated tests.
* Don't store dotfiles in the gemfile.
* Add a CITATION.cff file!

## Version 0.3.0

* Update badges for new repo location.
* Add back the coveralls badge for new repo location.
* Update gemspec with new repo location.
* Bump version number for 0.3.0 release.
* Add a Reference model to represent references.
* Wire the Reference model into Model and File.
* Add authors field to Reference.
* Read the author field properly when parsing a Reference.
* Remove the ModelPart constructor.
* Add the DOI badge to the README.
* Add the simple string fields to Reference.
* Add format field to Reference.
* Move duplicated builder methods to Util module.
* Remove the Util module from the public API.
* Restrict reference type to the defined set.
* Add Date type fields to the Reference model.
* Add contact to the Reference model.
* Add editors to the Reference model.
* Add editors-series to the Reference model.
* Add recipients to the Reference model.
* Add senders to the Reference model.
* Add translators to the Reference model.
* Refactor the Reference#fields method for complexity.
* Refactor the Model#to_yaml method for complexity.
* Restrict reference status to the defined set.
* Add languages to the Reference model.
* Restrict reference licence to the SPDX Licence List.
* Rename Util array_to_fields to expand_array_field.
* Add a Util method expand_field.
* Correctly read in the actor lists from a file.
* Update quick start example in the README.
* Add the integer fields to the Reference model.
* Refactor Reference#fields to cope with single Entities.
* Add the singular Entity fields to the Reference model.
* Add issue-date field to the Reference model.
* Add the keywords field to the Reference model.
* Refactor keyword list initialization in Reference.
* Add patent-states field to the Reference model.
* Refactor Reference#keywords to be a standard field.
* Refactor Reference#patent_states to be a field.
* Extend the tests for Reference after the refactor.
* Normalize Reference types when they are set.
* Normalize the Reference status when set.
* Add a note to the README about versioning.
* Add a CHANGES file.

## Version 0.2.0

* Add a rubygems version badge to the README.
* Add older rubies to the CI, but allow failures.
* Add the licence to the gemspec.
* Rename the ALLOWED_METHODS list to FIELDS.
* Send missing methods straight to Model, from File.
* Fix passing through arguments for missing methods (File).
* Add a Util module with delete_from_hash as first utility.
* Move method_to_field to the Util module.
* Refactor for more complete parsing ability.
* Freeze the allowed fields constant in Model.
* Change allowed fields to be more flexible
* Add abstract to Model.
* Factor out the process of converting array fields to yaml.
* Fix test for authors that was split incorrectly.
* Add contact to Model.
* Add tests to check capitalized fields are rejected.
* Refactor model building for maintainability.
* Add commit to the Model.
* Add doi to the Model.
* Add keywords to Model.
* Fix #11: prevent serialization of empty collections.
* Add license to Model.
* Refactor testing simple fields.
* Add license-url to Model.
* Simplify parsing the keywords in Model.
* Refactor testing reading complete CFF file.
* Add repository* to Model.
* Add url to Model.
* Fix #12: typo in README example usage.
* Add to the quick start example in the README.
* Create a new base class (ModelPart) for parts of the model.
* Add ModelPart#method_missing.
* Add affiliation to Person, and tests for it too.
* Add address to Entity, and tests for it too.
* Add accessors for required fields on Person, Entity.
* Add the rest of the optional fields in Person.
* Add the rest of the simple fields in Entity.
* Add the date fields in Entity.
* Test dates in Entity with text inputs.

## Version 0.1.0

* Add a code of conduct.
* Add Travis configuration.
* Add licence text to all source files.
* Add a Travis badge to the README.
* Add a CodeClimate badge to the README.
* Set up coveralls integration.
* Add a coveralls badge to the README.
* Add the current CFF spec version as the default.
* Add a simple model class.
* Message doesn't need to be passed to new.
* Add title to model and wire into default message.
* Add a method to set the message.
* Remove the default values on ingestion.
* Swap requires in main cff file.
* Only set a default message on construction.
* Add a File class to read and write CFF files.
* Switch to using standard accessor for message field.
* Streamline title output tests.
* Add a set title method to Model and test it.
* Turn off line wrapping in Model yaml output.
* Fix #2. Don't include title in the default message.
* Test that yaml output doesn't include the header.
* Write cff from a String or Model.
* Fix #3. Create a File from either a model or title.
* When testing file loading, compare to yaml directly.
* Test the message is loaded correctly into a File.
* Add version to the Model and File APIs.
* Add date-released to the Model and File APIs.
* Fix cff_version test.
* Move the Model class to a Hash-based implementation.
* Initialize Model with a title or a Hash.
* Update the File class to use the new Model class.
* Use a method whitelist for Model and File.
* Add a Person model to represent authors.
* Add an Entity model to represent authors.

## About this file

This file is, at least in part, generated by the following command:

```shell
$ git log --pretty=format:"* %s" --reverse --no-merges <commit-hash>..
```
