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

.PHONY: setup-base16-shell
setup-base16-shell: ## Setup base16-shell
	./scripts/setup-base16-shell.sh

.PHONY: setup-tmux
setup-tmux: ## Setup tmux
	./scripts/setup-tmux.sh

.PHONY: setup-vim-plugins
setup-vim-plugins: ## Setup vim plugins
	./scripts/setup-vim-plugins.sh

.PHONY: setup
setup: setup-base16-shell setup-tmux setup-vim-plugins ## Setup all

.PHONY: update-base16-shell
update-base16-shell: ## Update base16-shell
	./scripts/update-base16-shell.sh

.PHONY: update-vim-plugins
update-vim-plugins: ## Update vim plugins
	vim +PlugUpgrade +PlugUpdate +qa

.PHONY: update
update: update-base16-shell update-vim-plugins ## Update

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
