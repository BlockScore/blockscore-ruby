#!/bin/bash
RUBY_VERSIONS=(2.0.0-p645 2.1.6 2.2.2)
CIRCLE_NODE_RUBY_VERSION="${RUBY_VERSIONS[$CIRCLE_NODE_INDEX]}"
NUM_RUBIES=${#RUBY_VERSIONS[@]}

# Fail build if # ruby versions is greater than number of containers
if [ $CIRCLE_NODE_TOTAL -lt $NUM_RUBIES ]; then
  echo "Cannot test $NUM_RUBIES ruby versions on $CIRCLE_NODE_TOTAL containers"
  exit 1
fi

# Exit early if there are more containers than ruby versions to test
if [ $CIRCLE_NODE_INDEX -gt $(($NUM_RUBIES-1)) ]; then
  echo "Ignoring extra container"
  exit 0
fi

if [[ "$1" = "build" ]]
then
  rvm-exec $CIRCLE_NODE_RUBY_VERSION bundle install;
elif [[ "$1" = "spec" ]]
then
  rvm-exec $CIRCLE_NODE_RUBY_VERSION rspec;
fi
