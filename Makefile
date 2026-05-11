STOW_DIR    := home
STOW_TARGET := $(HOME)
STOW_FLAGS  := --target=$(STOW_TARGET) --dir=. --no-folding

.PHONY: list
list:
	@ls -AlF $(STOW_DIR)/

.PHONY: link
link:
	@command -v stow >/dev/null 2>&1 || { \
		echo "stow not found, installing via Homebrew..."; \
		brew install stow; \
	}
	stow $(STOW_FLAGS) $(STOW_DIR)

.PHONY: unlink
unlink:
	stow $(STOW_FLAGS) -D $(STOW_DIR)

.PHONY: relink
relink:
	stow $(STOW_FLAGS) -R $(STOW_DIR)

.PHONY: update
update: update-brew update-asdf-plugins update-base16-shell update-vim-plugins update-nvim-plugins update-zimfw

.PHONY: update-brew
update-brew:
	brew update && brew upgrade

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

.PHONY: cleanup
cleanup:
	brew cleanup
	docker system prune -f
