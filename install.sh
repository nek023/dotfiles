#!/usr/bin/env bash

# Detect role
ROLE=$(echo $(uname) | tr "[:upper:]" "[:lower:]")
NODE=nodes/${ROLE}.yml
RECIPE=roles/${ROLE}/default.rb

# Install gems
gem install bundler
bundle install --path=vendor/bundle

# Run provisioning
bundle exec itamae local ${RECIPE} -y ${NODE}
