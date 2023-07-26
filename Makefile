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
setup: setup-git

.PHONY: setup-git
setup-git:
	./scripts/setup-git.sh

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
