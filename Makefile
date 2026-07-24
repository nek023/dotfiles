STOW_DIR    := home
STOW_TARGET := $(HOME)
STOW_FLAGS  := --target=$(STOW_TARGET) --dir=. --no-folding

.PHONY: list
list:
	@STOW_DIR=$(STOW_DIR) STOW_TARGET=$(STOW_TARGET) ./scripts/list.sh

.PHONY: link
link:
	stow $(STOW_FLAGS) $(STOW_DIR)
	@$(MAKE) link-herdr-plugins

.PHONY: link-herdr-plugins
link-herdr-plugins:
	@STOW_DIR=$(STOW_DIR) ./scripts/herdr-plugins.sh

.PHONY: unlink
unlink:
	stow $(STOW_FLAGS) -D $(STOW_DIR)

.PHONY: relink
relink:
	stow $(STOW_FLAGS) -R $(STOW_DIR)

.PHONY: adopt
adopt:
	stow $(STOW_FLAGS) -R --adopt $(STOW_DIR)

.PHONY: update
update:
	$(MAKE) update-brew
	$(MAKE) update-vim-plugins
	$(MAKE) -j update-base16-shell update-nvim-plugins update-zimfw

.PHONY: update-base16-shell
update-base16-shell:
	./scripts/update-base16-shell.sh

.PHONY: update-brew
update-brew:
	brew update && brew upgrade -y

.PHONY: update-mise
update-mise:
	@command -v mise >/dev/null 2>&1 && mise upgrade || true

.PHONY: update-nvim-plugins
update-nvim-plugins:
	@command -v nvim >/dev/null 2>&1 && nvim --headless "+Lazy! sync" +qa || true

.PHONY: update-vim-plugins
update-vim-plugins:
	./scripts/update-vim-plugins.sh

.PHONY: update-zimfw
update-zimfw:
	@zsh -i -c '(( $${+functions[zimfw]} )) || exit 0; zimfw upgrade && zimfw update'

.PHONY: cleanup
cleanup:
	brew cleanup
	docker system prune -f
