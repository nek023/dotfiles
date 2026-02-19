CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .editorconfig .git .gitignore
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.PHONY: list
list:
	@$(foreach fn, $(DOTFILES), ls -dF $(fn);)

.PHONY: link
link:
	@$(foreach fn, $(DOTFILES), \
		if [ -d "$(HOME)/$(fn)" ] && [ ! -L "$(HOME)/$(fn)" ]; then \
			echo "WARN: $(HOME)/$(fn) is a real directory, skipping"; \
		else \
			ln -sfnv $(abspath $(fn)) $(HOME)/$(fn); \
		fi; \
	)

.PHONY: unlink
unlink:
	@$(foreach fn, $(DOTFILES), \
		if [ -L "$(HOME)/$(fn)" ]; then \
			rm -vf $(HOME)/$(fn); \
		elif [ -e "$(HOME)/$(fn)" ]; then \
			echo "WARN: $(HOME)/$(fn) is not a symlink, skipping"; \
		fi; \
	)

.PHONY: relink
relink: unlink link

.PHONY: update
update: update-asdf-plugins update-base16-shell update-vim-plugins update-nvim-plugins update-zimfw

.PHONY: update-asdf-plugins
update-asdf-plugins:
	./scripts/update-asdf-plugins.sh

.PHONY: update-base16-shell
update-base16-shell:
	./scripts/update-base16-shell.sh

.PHONY: update-vim-plugins
update-vim-plugins:
	./scripts/update-vim-plugins.sh

.PHONY: update-nvim-plugins
update-nvim-plugins:
	./scripts/update-nvim-plugins.sh

.PHONY: update-zimfw
update-zimfw:
	./scripts/update-zimfw.sh
