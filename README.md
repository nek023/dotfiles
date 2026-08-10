# dotfiles

[![Build](https://github.com/nek023/dotfiles/actions/workflows/build.yaml/badge.svg)](https://github.com/nek023/dotfiles/actions/workflows/build.yaml)

Set up a brand-new machine (installs Homebrew, clones this repository and dotfiles-private, links everything, and runs `mise install`):

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/nek023/dotfiles/main/scripts/bootstrap.sh)"
```

Or from an existing checkout:

```sh
git clone git@github.com:nek023/dotfiles.git ~/dotfiles
cd ~/dotfiles
make bootstrap
```
