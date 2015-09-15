#!/bin/bash
RUBY_VERSIONS=(2.0.0-p647 2.1.7 2.2.3)
CIRCLE_NODE_RUBY_VERSION="${RUBY_VERSIONS[$CIRCLE_NODE_INDEX]}"

if [[ "$1" = "build" ]]
then
  rvm-exec $CIRCLE_NODE_RUBY_VERSION bundle install;
elif [[ "$1" = "spec" ]]
then
  rvm-exec $CIRCLE_NODE_RUBY_VERSION rspec;
fi
