# blockscore-ruby

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/BlockScore/blockscore-ruby/blob/master/LICENSE)
[![Circle CI](https://img.shields.io/circleci/project/BlockScore/blockscore-ruby/master.svg?style=flat-square)](https://circleci.com/gh/BlockScore/blockscore-ruby)
[![Code Climate](https://img.shields.io/codeclimate/github/BlockScore/blockscore-ruby.svg?style=flat-square)](https://codeclimate.com/github/BlockScore/blockscore-ruby)
[![Test Coverage](https://img.shields.io/codeclimate/coverage/github/BlockScore/blockscore-ruby.svg?style=flat-square)](https://codeclimate.com/github/BlockScore/blockscore-ruby/coverage)
[![Dependency Status](https://img.shields.io/gemnasium/BlockScore/blockscore-ruby.svg?style=flat-square)](https://gemnasium.com/BlockScore/blockscore-ruby)

This is the official library for Ruby clients of the BlockScore API. [Click here to read the full documentation including code examples](http://docs.blockscore.com/ruby/).

## Install

Via rubygems.org:

```ruby
gem install blockscore
```

If you are using Rails, add the following to your `Gemfile`:

```ruby
gem 'blockscore', '~> 4.2.1'
```

## Getting Started

To get started, you can initialize the library with one line:

```ruby
BlockScore.api_key = 'your-api-key'
```

To verify a person:

```ruby
person = BlockScore::Person.create(
  birth_day: '23',
  birth_month: '8',
  birth_year: '1980',
  document_type: 'ssn',
  document_value: '0000',
  name_first: 'John',
  name_middle: 'Pearce',
  name_last: 'Doe',
  address_street1: '1 Infinite Loop',
  address_street2: 'Apt 6',
  address_city: 'Cupertino',
  address_subdivision: 'CA',
  address_postal_code: '95014',
  address_country_code: 'US'
)

# Check the validation status of the Person
person.status
# => 'valid'

# Or view some of the other attributes
person.details.address
# => 'mismatch'
```

To see the list of calls you can make, please visit our [full Ruby API reference](http://docs.blockscore.com/ruby/).

## Testing

In order to run the test suite:

```shell
$ rspec
```
