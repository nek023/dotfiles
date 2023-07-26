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

.PHONY: relink
relink: unlink link

.PHONY: setup
setup: setup-asdf-plugins setup-base16-shell setup-git setup-vim-plugins

.PHONY: setup-asdf-plugins
setup-asdf-plugins:
	./scripts/setup-asdf-plugins.sh

.PHONY: setup-base16-shell
setup-base16-shell:
	./scripts/setup-base16-shell.sh

.PHONY: setup-git
setup-git:
	./scripts/setup-git.sh

.PHONY: setup-vim-plugins
setup-vim-plugins:
	./scripts/setup-vim-plugins.sh

.PHONY: update
update: update-asdf-plugins update-base16-shell update-vim-plugins

.PHONY: update-asdf-plugins
update-asdf-plugins:
	./scripts/update-asdf-plugins.sh

.PHONY: update-base16-shell
update-base16-shell:
	./scripts/update-base16-shell.sh

.PHONY: update-vim-plugins
update-vim-plugins:
	./scripts/update-vim-plugins.sh
