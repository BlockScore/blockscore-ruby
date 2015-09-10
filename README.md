# blockscore-ruby [![Circle CI](https://circleci.com/gh/BlockScore/blockscore-ruby/tree/master.svg?style=shield)](https://circleci.com/gh/BlockScore/blockscore-ruby) [![Test Coverage](https://codeclimate.com/github/BlockScore/blockscore-ruby/badges/coverage.svg)](https://codeclimate.com/github/BlockScore/blockscore-ruby/coverage) [![Dependency Status](https://gemnasium.com/BlockScore/blockscore-ruby.svg)](https://gemnasium.com/BlockScore/blockscore-ruby)

This is the official library for Ruby clients of the BlockScore API. [Click here to read the full documentation including code examples](http://docs.blockscore.com/ruby/).

## Install

Via rubygems.org:

```ruby
gem install blockscore
```

If you are using Rails, add the following to your `Gemfile`:

```ruby
gem 'blockscore', '~> 4.1.2'
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

The test suite uses a public BlockScore API key that was created specifically to ease the testing and contribution processes. **Please do not enter personal details for tests.** In order to run the test suite:

```shell
$ rspec spec
```
