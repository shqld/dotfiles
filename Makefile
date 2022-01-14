# Copyright (c) 2021- shqld All Rights Reserved.
# https://github.com/shqld/dotfiles/blob/master/Makefile

DOTPATH         := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES      := $(wildcard .??*) Library
EXCLUSIONS      := .DS_Store .git .gitignore .make .submodules
DOTFILES        := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

SUBMODULES      := https://github.com/zsh-users/zsh-syntax-highlighting
SUBMODULES      += https://github.com/b4b4r07/enhancd
SUBMODULES      += https://github.com/romkatv/gitstatus
SUBMODULES      += https://github.com/zsh-users/zsh-autosuggestions
SUBMODULES      += https://github.com/junegunn/vim-plug
SUBMODULES      += https://github.com/romainl/Apprentice

SSH_KEY_PATH    := $(shell grep IdentityFile .ssh/config | sed 's/IdentityFile //g')

.DEFAULT_GOAL   := help

all:
init: link install clone ## Initialize the environment
clean: unlink uninstall unclone ## Remove the dot files and this repo

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), ls -dF $(val);)

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

uninstall: ## Uninstall Homebrew dependencies not listed from the Brewfile
	@brew bundle cleanup --file=$(DOTPATH)/Brewfile

clone: ## Clone subordinate git modules
	@-cd .submodules; echo $(SUBMODULES) | xargs -n1 git clone --depth 1

unclone: ## Remove all cloned subordinate git modules
	@cd .submodules; rm -rf *

keygen: ## Generate ssh key automatically according to '.ssh/config'
	@$(foreach val, $(SSH_KEY_PATH), \
        test -f $(val) || ( \
            mkdir -p $(dir $(val)); ssh-keygen -b 4096 -t ed25519 -N '' -C 'shqld@$(shell hostname)' -f $(val) \
        ); \
    )

setup.vscode: install
    ## Install VSCode extensions listed vscode_extensions.txt
	@-xargs -n1 code --install-extension < vscode_extensions.txt
