# blockscore-ruby
[![Circle CI](https://circleci.com/gh/BlockScore/blockscore-ruby/tree/master.svg?style=shield)](https://circleci.com/gh/BlockScore/blockscore-ruby/tree/4.1.0) [![Code Climate](https://codeclimate.com/github/BlockScore/blockscore-ruby/badges/gpa.svg)](https://codeclimate.com/github/BlockScore/blockscore-ruby) [![Test Coverage](https://codeclimate.com/github/BlockScore/blockscore-ruby/badges/coverage.svg)](https://codeclimate.com/github/BlockScore/blockscore-ruby/coverage) [![Dependency Status](https://gemnasium.com/BlockScore/blockscore-ruby.svg)](https://gemnasium.com/BlockScore/blockscore-ruby)

This is the official library for Ruby clients of the BlockScore API. [Click here to read the full documentation including code examples](http://docs.blockscore.com/v4.0/ruby/).

## Install

Via rubygems.org:

```ruby
gem install blockscore
```

If you are using Rails, add the following to your `Gemfile`:

```ruby
gem 'blockscore', '~> 4.1.0'
```

## Getting Started

To get started, you can initialize the library with one line:

```ruby
BlockScore.api_key = 'your-api-key'
```

Create a Person:

```ruby
person = BlockScore::Person.create(
  birth_day: "23",
  birth_month: "8",
  birth_year: "1980",
  document_type: "ssn",
  document_value: "0000",
  name_first: "John",
  name_middle: "Pearce",
  name_last: "Doe",
  address_street1: "1 Infinite Loop",
  address_street2: "Apt 6",
  address_city: "Cupertino",
  address_state: "CA",
  address_postal_code: "95014",
  address_country_code: "US"
)

# Check the validation status of the Person
person.status
# => true

# Or view some of the other attributes
person.details[:ofac]
# => "no_match"

person.address_city
# => "Cupertino"

person.id
# => "544744f43266330002010000"

# ...
```

To see the list of calls you can make, please visit out [full Ruby API reference](http://docs.blockscore.com/v4.0/ruby).

## Exceptions and Errors

### Error Description

* The generic error class is BlockScoreError. All other types of errors are derived from BlockScoreError.
* Errors contain information such as the HTTP response code, a short message describing the error, the type of error, and if applicable, the parameter and error code at issue.
* Also available in the error object is the full JSON text representation of the data.

### Error Types

* BlockScoreError (Generic error, base class)
* InvalidRequestError (400 : Input could not be validated)
* InvalidRequestError (400 : Missing parameter)
* AuthenticationError (401 : Invalid API Key)
* InvalidRequestError (404 : Attempting to reference nonexistent endpoint)
* APIError (500 : Error on the Blockscore API)

## Running the test suite

The test suite uses a public BlockScore API key that was created specifically to ease the testing and contribution processes. With that being said:

*DO NOT REPLACE THE PROVIDED TEST PARAMETERS WITH ANY SENSITIVE INFORMATION AS ANYTHING SENT TO THE API USING THE PROVIDED TEST KEY WILL BE __PUBLIC__ AND AVAILABLE TO BOTS AND HUMANS ALIKE.*

In order to run the test suite:

```shell
$ rake test
```

## Contributing to BlockScore

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 BlockScore. See LICENSE.txt for
further details.
