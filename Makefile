DOTFILES_DIR      := $(PWD)/dotfiles
DOTFILES_TARGET   := $(notdir $(wildcard $(DOTFILES_DIR)/.??*)) bin
DOTFILES_EXCLUDES := .DS_Store
DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

all: update link install
	@exec $$SHELL

help:
	@echo "make all          Update repo, link dotfiles and run provisioning"
	@echo "make update       Update this repo"
	@echo "make list         List dotfiles"
	@echo "make link         Link dotfiles"
	@echo "make unlink       Unlink dotfiles"
	@echo "make install      Run provisioning"

update:
	git pull origin master

list:
	@$(foreach val, $(DOTFILES_FILES), ls -dF $(DOTFILES_DIR)/$(val);)

link:
	@$(foreach val, $(DOTFILES_FILES), ln -sfnv $(DOTFILES_DIR)/$(val) $(HOME)/$(val);)

unlink:
	@-$(foreach val, $(DOTFILES_FILES), rm -vrf $(HOME)/$(val);)

install:
	bash install.sh
