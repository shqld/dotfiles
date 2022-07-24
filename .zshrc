# =====================================================
# GLOBAL BIN PATH
# -----------------------------------------------------

export GOPATH=$HOME
export KTROOT=$HOME/.kotlin

export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/sbin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.zsh/funcs:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH 
export PATH=$GOPATH/bin:$PATH
export PATH=$KTROOT/bin:$PATH
export PATH=$HOME/Users/sho/Library/Android/sdk/platform-tools:$PATH
export PATH=$HOME/Library/Python/2.7/bin:$PATH
export PATH=/usr/local/Cellar/python3/3.6.4/Frameworks/Python.framework/Versions/3.6/bin:$PATH
export PATH=$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH
export PATH=$HOME/ghq/github.com/kamatama41/tfenv/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/opt/curl/bin:$PATH
export PATH=$HOME/ghq/chromium.googlesource.com/chromium/tools/depot_tools:$PATH
export PATH=$(brew --prefix llvm)/bin:$PATH

# source /opt/lucet/bin/devenv_setenv.sh

# =====================================================
# ALIAS
# -----------------------------------------------------

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
alias gm=$HOME/ghq/chromium.googlesource.com/v8/v8/tools/dev/gm.py

# =====================================================
# ENVIRONMENT VARIABLES
# -----------------------------------------------------

# export LANG=ja_JP.UTF-8
export LANG=en_US.UTF-8
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export FZF_DEFAULT_COMMAND='fd --type f'
export EDITOR=/usr/bin/vim

# =====================================================
# ZSH LINE EDITOR
# -----------------------------------------------------

# set -o vi
bindkey -v

bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^B'  backward-char
bindkey -M viins '^D'  delete-char-or-list
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^F'  forward-char
bindkey -M viins '^G'  send-break
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^K'  kill-line
bindkey -M viins '^N'  down-line-or-history
bindkey -M viins '^P'  up-line-or-history
bindkey -M viins '^R'  history-incremental-pattern-search-backward
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^W'  backward-kill-word
bindkey -M viins '^Y'  yank

# =====================================================
# INITIALIZE
# -----------------------------------------------------

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

autoload -Uz compinit
compinit -u

source ~/.zsh/enhancd/init.sh
source ~/.zsh/gitstatus/gitstatus.prompt.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(direnv hook zsh)"

source "$HOME/.cargo/env"

# =====================================================
# ZSH CONFIG
# -----------------------------------------------------

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# 直前のコマンドの重複を削除
setopt hist_ignore_dups
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
# 同時に起動したzshの間でヒストリを共有
# setopt share_history

if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧をカラー表示
zstyle ':completion:*' list-colors ''

# コマンドのスペルを訂正
# setopt correct
# ビープ音を鳴らさない
setopt no_beep

# prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd() { vcs_info }
PROMPT='%F{magenta}%~%f %F{yellow}$%f '
RPROMPT='${vcs_info_msg_0_}'

# fzf 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# gcloud
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/sho/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/sho/Downloads/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/sho/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/sho/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
