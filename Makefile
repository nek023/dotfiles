DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git .gitignore
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

all:

help:
	@echo "Usage:"
	@echo "make list         List dotfiles"
	@echo "make link         Link dotfiles"
	@echo "make unlink       Unlink dotfiles"

list:
	@$(foreach val, $(DOTFILES), ls -dF $(val);)

link:
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

unlink:
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)
