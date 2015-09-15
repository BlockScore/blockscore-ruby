#!/bin/bash
RUBY_VERSIONS=(2.0.0-p645 2.1.6 2.2.2)
CIRCLE_NODE_RUBY_VERSION="${RUBY_VERSIONS[$CIRCLE_NODE_INDEX]}"

if [[ "$1" = "build" ]]
then
  rvm-exec $CIRCLE_NODE_RUBY_VERSION bundle install;
elif [[ "$1" = "spec" ]]
then
  rvm-exec $CIRCLE_NODE_RUBY_VERSION rspec;
fi
