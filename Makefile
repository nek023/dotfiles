DATA_DIR := $(PWD)/data
TARGETS  := $(notdir $(wildcard $(DATA_DIR)/.??*)) bin
EXCLUDES := .DS_Store
DOTFILES := $(filter-out $(EXCLUDES), $(TARGETS))

all: link

help:
	@echo "Usage:"
	@echo "make list         List dotfiles"
	@echo "make link         Link dotfiles"
	@echo "make unlink       Unlink dotfiles"

list:
	@$(foreach file, $(DOTFILES), ls -dF $(DATA_DIR)/$(file);)

link:
	@$(foreach file, $(DOTFILES), ln -sfnv $(DATA_DIR)/$(file) $(HOME)/$(file);)

unlink:
	@-$(foreach file, $(DOTFILES), rm -vrf $(HOME)/$(file);)
