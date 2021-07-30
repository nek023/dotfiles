CANDIDATES ?= $(wildcard .??*)
EXCLUSIONS ?= .DS_Store .git .gitignore
DOTFILES   ?= $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.PHONY: list
list:
	@$(foreach fn, $(DOTFILES), ls -dF $(fn);)

.PHONY: link
link:
	@$(foreach fn, $(DOTFILES), ln -sfnv $(abspath $(fn)) $(HOME)/$(fn);)

.PHONY: unlink
unlink:
	@-$(foreach fn, $(DOTFILES), rm -vrf $(HOME)/$(fn);)

.PHONY: setup-base16-shell
setup-base16-shell:
	./scripts/setup-base16-shell.sh

.PHONY: setup-vim-plugins
setup-vim-plugins:
	./scripts/setup-vim-plugins.sh

.PHONY: setup
setup: setup-base16-shell setup-vim-plugins

.PHONY: update-asdf-plugins
update-asdf-plugins:
	./scripts/update-asdf-plugins.sh

.PHONY: update-base16-shell
update-base16-shell:
	./scripts/update-base16-shell.sh

.PHONY: update-vim-plugins
update-vim-plugins:
	./scripts/update-vim-plugins.sh

.PHONY: update
update: update-asdf-plugins update-base16-shell update-vim-plugins

.PHONY: link-vscode-settings
link-vscode-settings:
	@test -d $(HOME)/Library/Application\ Support/Code/User \
		&& test ! -e $(HOME)/Library/Application\ Support/Code/User/settings.json \
		&& ln -sfnv $(HOME)/dotfiles/.config/vscode/settings.json $(HOME)/Library/Application\ Support/Code/User/settings.json \
		|| :

.PHONY: unlink-vscode-settings
unlink-vscode-settings:
	@test -L $(HOME)/Library/Application\ Support/Code/User/settings.json \
		&& rm -vrf $(HOME)/Library/Application\ Support/Code/User/settings.json \
		|| :

.PHONY: dump-vscode-extensions
dump-vscode-extensions:
	./scripts/dump-vscode-extensions.sh > $(HOME)/dotfiles/.config/vscode/extensions

.PHONY: install-vscode-extensions
install-vscode-extensions:
	./scripts/install-vscode-extensions.sh $(HOME)/dotfiles/.config/vscode/extensions
