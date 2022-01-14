# Copyright (c) 2021- shqld All Rights Reserved.
# https://github.com/shqld/dotfiles/blob/master/Makefile

DOTPATH         := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES      := $(wildcard .??*) Library
EXCLUSIONS      := .DS_Store .git .gitignore .make .submodules
DOTFILES        := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL   := help

all:

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

link: ## Create symlinks to home directory
	@-$(foreach val, $(DOTFILES), find $(val) -type d | xargs -I{} mkdir $(HOME)/{};) # Always parent dirs come first via 'find'
    # Only files or symlinks, not to overwrite existing directories (e.g. '.ssh', '.config')
	@$(foreach val, $(DOTFILES), find $(val) -type f -o -type l | xargs -I{} ln -sfnv $(abspath {}) $(HOME)/{};)

unlink: ## Remove all symlinks for the dot files
    # Only files or symlinks, not to remove other files in the directories
	@-$(foreach val, $(DOTFILES), find $(val) -type f -o -type l | xargs -I{} rm -v $(HOME)/{};)
    # Remove empty directories
	@-$(foreach val, $(DOTFILES), find $(val) -type d | xargs -I{} rm -vd $(HOME)/{};)

install: ## Install Homebrew dependencies listed from the Brewfile
	@which -s brew || (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash)
	@brew bundle install --file=$(DOTPATH)/Brewfile
	@brew bundle dump --force --file=$(DOTPATH)/Brewfile
