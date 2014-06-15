# blockscore-ruby

This is the official library for Ruby clients of the BlockScore API. [Click here to read the full documentation](https://manage.blockscore.com/docs).

## Install

Via rubygems.org:

```ruby
gem install blockscore
```

If you are using Rails, add the following to your `Gemfile`:

```ruby
gem 'blockscore', '~> 1.0.1'
```

## Getting Started

To get started, you can initialize the library with one line:

```ruby
client = BlockScore::Client.new('your-api-key', version = 2)
```

To see the list of calls you can make, please visit out [full Ruby API reference](http://docs.blockscore.com/ruby).

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

