

# GLOBAL BIN PATH
# ===============

export GOPATH=$HOME
export KTROOT=$HOME/.kotlin
export GHQ_ROOT=$HOME/ghq

export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/opt/curl/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.zsh/funcs:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH 
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
export PATH=$HOME/Library/Python/2.7/bin:$PATH
export PATH=$HOME/.yarn/bin:$PATH
export PATH=$HOME/.config/yarn/global/node_modules/.bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH=$KTROOT/bin:$PATH
export PATH=$GHQ_ROOT/github.com/kamatama41/tfenv/bin:$PATH
export PATH=$GHQ_ROOT/chromium.googlesource.com/chromium/tools/depot_tools:$PATH
export PATH=$(brew --prefix python3)/bin:$PATH
export PATH=$(brew --prefix llvm)/bin:$PATH

# source /opt/lucet/bin/devenv_setenv.sh


# ALIAS
# =====

alias g='git'
alias up='cd ..'

alias nn='nnn'

alias ls='exa'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

alias cat='bat'

alias pbp='pbpaste'
alias pbc='pbcopy'

alias qurl='docker run -it --rm ymuski/curl-http3 curl'

alias tf='terraform'

## projects/v8
alias gm=$GHQ_ROOT/chromium.googlesource.com/v8/v8/tools/dev/gm.py


# ENVIRONMENT VARIABLES
# =====================

# export LANG=ja_JP.UTF-8
export LANG=en_US.UTF-8
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export EDITOR=/usr/bin/vim
export NODE_OPTIONS='--enable-source-maps --trace-warnings'


# INITIALIZE
# ==========

[ -f $HOME/.zshrc.config ] && source $HOME/.zshrc.config
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

autoload -Uz compinit
compinit -u

source $HOME/.zsh/enhancd/init.sh
source $HOME/.zsh/gitstatus/gitstatus.prompt.zsh
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(direnv hook zsh)"

# cargo
source "$HOME/.cargo/env"

# fzf 
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# gcloud
# updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi
# enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi
