#!/bin/bash

set -eu

cat $(find ~/.ghq -name .ruby-version -type f -maxdepth 4) | sort | uniq
