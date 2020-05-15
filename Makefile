CANDIDATES ?= $(wildcard .??*) bin
EXCLUSIONS ?= .DS_Store .git .gitignore
DOTFILES   ?= $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show help
	@echo 'Commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

.PHONY: list
list: ## List dotfiles
	@$(foreach fn, $(DOTFILES), ls -dF $(fn);)

.PHONY: link
link: ## Link dotfiles
	@$(foreach fn, $(DOTFILES), ln -sfnv $(abspath $(fn)) $(HOME)/$(fn);)

.PHONY: unlink
unlink: ## Unlink dotfiles
	@-$(foreach fn, $(DOTFILES), rm -vrf $(HOME)/$(fn);)

.PHONY: brew-dump
brew-dump: ## Write installed packages into ~/.Brewfile
	@brew bundle dump --global --force

.PHONY: brew-install
brew-install: ## Install packages in ~/.Brewfile
	@brew bundle --global
