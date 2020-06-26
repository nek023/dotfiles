CANDIDATES ?= $(wildcard .??*)
EXCLUSIONS ?= .DS_Store .git .gitignore
DOTFILES   ?= $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show help
	@echo 'Commands:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-28s\033[0m %s\n", $$1, $$2}'

.PHONY: list
list: ## List dotfiles
	@$(foreach fn, $(DOTFILES), ls -dF $(fn);)

.PHONY: link
link: ## Link dotfiles
	@$(foreach fn, $(DOTFILES), ln -sfnv $(abspath $(fn)) $(HOME)/$(fn);)

.PHONY: unlink
unlink: ## Unlink dotfiles
	@-$(foreach fn, $(DOTFILES), rm -vrf $(HOME)/$(fn);)

.PHONY: setup-anyenv
setup-anyenv: ## Setup anyenv
	@./scripts/setup-anyenv.sh

.PHONY: setup-base16-shell
setup-base16-shell: ## Setup base16-shell
	@./scripts/setup-base16-shell.sh

.PHONY: setup-tmux
setup-tmux: ## Setup tmux
	@./scripts/setup-tmux.sh

.PHONY: setup-vim-plug
setup-vim-plug: ## Setup vim-plug
	@./scripts/setup-vim-plug.sh

.PHONY: setup
setup: setup-anyenv setup-base16-shell setup-tmux setup-vim-plug ## Setup all

.PHONY: link-vscode-settings
link-vscode-settings: ## Link VSCode settings
	@test -d $(HOME)/Library/Application\ Support/Code/User \
		&& test ! -e $(HOME)/Library/Application\ Support/Code/User/settings.json \
		&& ln -sfnv $(HOME)/dotfiles/.config/vscode/settings.json $(HOME)/Library/Application\ Support/Code/User/settings.json \
		|| :

.PHONY: unlink-vscode-settings
unlink-vscode-settings: ## Unlink VSCode settings
	@test -L $(HOME)/Library/Application\ Support/Code/User/settings.json \
		&& rm -vrf $(HOME)/Library/Application\ Support/Code/User/settings.json \
		|| :

.PHONY: dump-vscode-extensions
dump-vscode-extensions: ## Dump VSCode extensions
	@./scripts/dump-vscode-extensions.sh > $(HOME)/dotfiles/.config/vscode/extensions

.PHONY: install-vscode-extensions
install-vscode-extensions: ## Install VSCode extensions
	@./scripts/install-vscode-extensions.sh $(HOME)/dotfiles/.config/vscode/extensions

.PHONY: update-vim-plugins
update-vim-plugins: ## Update vim plugins
	@vim +PlugUpgrade +PlugUpdate +qa
