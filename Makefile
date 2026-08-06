STOW_DIR    := home
STOW_TARGET := $(HOME)
STOW_FLAGS  := --target=$(STOW_TARGET) --dir=. --no-folding

# A bare machine has neither on PATH yet: nix arrives with nix-install, and
# stow with the first switch. Neither reaches the PATH make started with.
NIX_BIN := /nix/var/nix/profiles/default/bin

# Calls make rather than listing prerequisites, which -j would reorder.
.PHONY: bootstrap
bootstrap:
	./scripts/bootstrap.sh
	@$(MAKE) nix-install
	@PATH="$(NIX_BIN):$$PATH" $(MAKE) switch
	@PATH="$(HM_BIN):$(NIX_BIN):$$PATH" $(MAKE) link

.PHONY: nix-install
nix-install:
	./scripts/nix-install.sh

DOTFILES_PRIVATE_DIR ?= $(HOME)/dotfiles-private

PROXY_ENV := $(if $(http_proxy),http_proxy=$(http_proxy) https_proxy=$(https_proxy),)
NIX_ENV   := $(PROXY_ENV) DOTFILES_PRIVATE_DIR=$(DOTFILES_PRIVATE_DIR)
NIX_FLAGS := --flake .\#default --impure

# nix run keeps the pinned tool, and works before it is on PATH.
NIX_RUN := nix run --impure .\#

ifeq ($(shell uname -s),Darwin)
DARWIN_REBUILD := $(NIX_RUN)darwin-rebuild --
SWITCH     := sudo $(NIX_ENV) $(DARWIN_REBUILD) switch $(NIX_FLAGS)
BUILD      := $(NIX_ENV) $(DARWIN_REBUILD) build $(NIX_FLAGS)
CHECK_ATTR := darwinConfigurations.default.system
HM_BIN     := /etc/profiles/per-user/$(USER)/bin
else
# Linux has no system layer, so home-manager runs standalone there.
HOME_MANAGER := $(NIX_RUN)home-manager --
SWITCH     := $(NIX_ENV) $(HOME_MANAGER) switch $(NIX_FLAGS)
BUILD      := $(NIX_ENV) $(HOME_MANAGER) build $(NIX_FLAGS)
CHECK_ATTR := homeConfigurations.default.activationPackage
HM_BIN     := $(HOME)/.nix-profile/bin
endif

.PHONY: switch
switch:
	$(SWITCH)

.PHONY: build
build:
	$(BUILD)

# Resolves the whole derivation graph without fetching or building it.
.PHONY: check
check:
	$(NIX_ENV) nix build --impure --dry-run .\#$(CHECK_ATTR)

.PHONY: brew-diff
brew-diff:
	@DOTFILES_PRIVATE_DIR=$(DOTFILES_PRIVATE_DIR) ./scripts/brew-diff.sh

MIN_RELEASE_DAYS ?= 7

.PHONY: brew-update
brew-update:
	brew update && brew upgrade -y

.PHONY: nix-update
nix-update:
	@MIN_RELEASE_DAYS=$(MIN_RELEASE_DAYS) ./scripts/nix-update.sh

GC_OLDER_THAN_DAYS ?= 14

.PHONY: nix-gc
nix-gc:
	nix-collect-garbage --delete-older-than $(GC_OLDER_THAN_DAYS)d
	sudo nix-collect-garbage --delete-older-than $(GC_OLDER_THAN_DAYS)d
	nix store optimise
.PHONY: mise-update
mise-update:
	@command -v mise >/dev/null 2>&1 && mise upgrade || true

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
	$(MAKE) brew-update
	$(MAKE) update-vim-plugins
	$(MAKE) -j update-base16-shell update-nvim-plugins update-zimfw

.PHONY: update-base16-shell
update-base16-shell:
	./scripts/update-base16-shell.sh

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
