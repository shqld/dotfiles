# Copyright (c) 2021- shqld All Rights Reserved.
# https://github.com/shqld/dotfiles/blob/master/Makefile

XARGS           := xargs -P$(shell nproc)

DOTPATH         := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES      := $(wildcard .??*) Library
EXCLUSIONS      := .DS_Store .git .gitignore .make .deps
DOTFILES        := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

DEPENDENCIES      := https://github.com/zsh-users/zsh-syntax-highlighting
DEPENDENCIES      += https://github.com/b4b4r07/enhancd
DEPENDENCIES      += https://github.com/romkatv/gitstatus
DEPENDENCIES      += https://github.com/zsh-users/zsh-autosuggestions
DEPENDENCIES      += https://github.com/junegunn/vim-plug
DEPENDENCIES      += https://github.com/romainl/Apprentice

SSH_KEY_PATH    := $(shell grep IdentityFile .ssh/config | sed 's/IdentityFile //g')

.DEFAULT_GOAL   := help

all:
init: link install clone setup ## Initialize the environment
clean: unlink uninstall unclone ## Remove the dot files and this repo

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

list: ## Show dot files in this repo
	@$(foreach val, $(DOTFILES), ls -dF $(val);)

link: ## Create symlinks to home directory
	@-$(foreach val, $(DOTFILES), find $(val) -type d | $(XARGS) -I{} mkdir $(HOME)/{};) # Always parent dirs come first via 'find'
    # Only files or symlinks, not to overwrite existing directories (e.g. '.ssh', '.config')
	@$(foreach val, $(DOTFILES), find $(val) -type f -o -type l | $(XARGS) -I{} ln -sfnv $(abspath {}) $(HOME)/{};)

unlink: ## Remove all symlinks for the dot files
    # Only files or symlinks, not to remove other files in the directories
	@-$(foreach val, $(DOTFILES), find $(val) -type f -o -type l | $(XARGS) -I{} rm -v $(HOME)/{};)
    # Remove empty directories
	@-$(foreach val, $(DOTFILES), find $(val) -type d | $(XARGS) -I{} rm -vd $(HOME)/{};)

install: ## Install Homebrew dependencies listed from the Brewfile
	@which -s brew || (curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash)
	@brew bundle install --no-lock --file=$(DOTPATH)/Brewfile
	@brew bundle dump --force --file=$(DOTPATH)/Brewfile

uninstall: ## Uninstall Homebrew dependencies not listed from the Brewfile
	@brew bundle cleanup --file=$(DOTPATH)/Brewfile

clone: ## Clone subordinate git modules
	@-cd .deps; echo $(DEPENDENCIES) | $(XARGS) -n1 git clone --depth 1

unclone: ## Remove all cloned subordinate git modules
	@cd .deps; rm -rf *

keygen: ## Generate ssh key automatically according to '.ssh/config'
	@$(foreach val, $(SSH_KEY_PATH), \
        test -f $(val) || ( \
            mkdir -p $(dir $(val)); ssh-keygen -b 4096 -t ed25519 -N '' -C 'shqld@$(shell hostname)' -f $(val) \
        ); \
    )

setup: setup.vscode setup.vim setup.fzf setup.node setup.chsh setup.keyrepeat setup.rust ## Setup miscellaneous

setup.vscode: install ## Install VSCode extensions listed vscode_extensions.txt
	@-$(XARGS) -n1 code --install-extension < vscode_extensions.txt

setup.vim: link clone ## Install plugins for plug.vim https://github.com/junegunn/vim-plug
	@vim +'PlugInstall --sync' +qa # https://github.com/junegunn/vim-plug/issues/675#issuecomment-328157169

setup.fzf: install link ## Install fzf keybindings and completion https://github.com/junegunn/fzf#using-homebrew
	@$(shell brew --prefix)/opt/fzf/install --all --no-bash --no-fish

setup.node: install ## Install node@latest via nodebrew
	@mkdir -p $(HOME)/.nodebrew/src
	@nodebrew install-binary latest
	@nodebrew use latest

setup.chsh: install ## Change default shell for the current user to zsh
	@grep -q $(shell which zsh) /etc/shells || echo $(shell which zsh) | sudo tee -a /etc/shells
	@finger $(shell whoami) | grep -q "Shell: $(shell which zsh)" || chsh -s $(shell which zsh)

setup.keyrepeat: ## Enable key repeating in vscode https://github.com/VSCodeVim/Vim/blob/2da276357ddfe6fba3640b04b05113bd3e66156b/README.md#mac
	@defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false # For VS Code
	@defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
	@defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false # For VS Codium
    # @defaults delete -g ApplePressAndHoldEnabled # If necessary, reset global default

setup.rust: ## Init rustup
	@rustup-init -y
	@rustup component add rls rust-analysis rust-src

