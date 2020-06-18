#!/bin/bash

set -eu

code --list-extensions | grep -v "unpublished."
