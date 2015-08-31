#!/bin/bash
RUBY_VERSIONS=(1.9.3-p551 2.0.0-p598 2.1.5 2.2.3)
CIRCLE_NODE_RUBY_VERSION="${RUBY_VERSIONS[$CIRCLE_NODE_INDEX]}"

if [[ "$1" = "build" ]]
then
  rvm-exec $CIRCLE_NODE_RUBY_VERSION bundle install;
elif [[ "$1" = "spec" ]]
then
  rvm-exec $CIRCLE_NODE_RUBY_VERSION rspec;
fi