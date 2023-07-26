#!/bin/bash

set -eu

curl -o "${XDG_CONFIG_HOME}/git/completion/git-prompt.sh" https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
