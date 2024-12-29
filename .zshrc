# General

## LANG
export LANG=ja_JP.UTF-8
#export LC_ALL=ja_JP.UTF-8

## color
autoload -Uz colors
colors

## plugins
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
else
    # ArchLinux
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


## zsh-completions
if [ -e /usr/local/share/zsh-completions ]; then
	fpath=(/usr/local/share/zsh-completions $fpath)
fi

autoload -Uz compinit
compinit -u

## completion option
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:cd:*' ignore-parents parent pwd

## history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

## options
setopt share_history
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt auto_cd
setopt auto_pushd
setopt correct

# powerlevel10k

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac
    source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
else
    # ArchLinux
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# alias
## update sudo expiration time
alias sudo='sudo -v; sudo '

## ls
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

## cd
# function; run ls after cd
cdls ()
{
\cd "$@" && ls --color=auto
}
alias cd="cdls"
alias work="cd ~/Workspace"
alias dot="cd ~/dotfiles"

## git
alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git push'
alias gb='git branch'
alias gf='git fetch'
alias gc='git commit'

## vim
alias vi="vim"
## neovim
alias nv="nvim"

## confirm destructive change
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# anyenv
if [ -d $HOME/.anyenv ]
then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
fi

# npm setting
export PATH="$PATH:$(npm bin -g)"

