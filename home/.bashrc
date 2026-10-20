#!/usr/bin/env bash

# ─────────────────────────────────────────────
# Interactive shell only
# ─────────────────────────────────────────────
[[ $- != *i* ]] && return

# Prykshift startup logo
# Show startup graphic only in a fresh terminal.
# Skip it inside Neovim and other embedded terminals.
if [[ -z "$NVIM" ]]; then

    awk '
    BEGIN {
        colors[1]="255;100;200"
        colors[2]="220;100;235"
        colors[3]="180;100;255"
        colors[4]="120;160;255"
        colors[5]="100;220;255"
    }
    {
        c = colors[((NR-1) % 5)+1]
        printf "\033[38;2;%sm%s\033[0m\n", c, $0
    }' ~/.config/fastfetch/prykshift.txt

    if command -v fastfetch &>/dev/null; then
        fastfetch --key-padding-left 5
    fi

fi

# ─────────────────────────────────────────────
# Programs
# ─────────────────────────────────────────────
export EDITOR="micro"
export VISUAL="micro"

export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33;44m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;1;32m'
export LESS_TERMCAP_mr=$'\e[7m'
export LESS_TERMCAP_mh=$'\e[2m'
export LESS_TERMCAP_ZN=$'\e[74m'
export LESS_TERMCAP_ZV=$'\e[75m'
export LESS_TERMCAP_ZO=$'\e[73m'
export LESS_TERMCAP_ZW=$'\e[75m'
export MANPAGER='less'
export PAGER="less"
export MANPAGER="less"

export LESS="-R"

# ─────────────────────────────────────────────
# History
# ─────────────────────────────────────────────
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000

shopt -s histappend

# Save history after every command instead of only
# when Bash exits.
PROMPT_COMMAND="history -a; history -n"

# ─────────────────────────────────────────────
# Bash behaviour
# ─────────────────────────────────────────────

# Automatically cd by typing a directory
shopt -s autocd

# Fix small spelling mistakes in `cd`
shopt -s cdspell
shopt -s dirspell

# Update terminal dimensions
shopt -s checkwinsize

# Better globbing
shopt -s extglob
shopt -s globstar

# ─────────────────────────────────────────────
# Colors
# ─────────────────────────────────────────────

alias ls='ls --color=auto'
alias lh='ls -lh'
alias grep='grep --color=auto'

export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;32m'
export LESS_TERMCAP_ue=$'\e[0m'

# Caelestia terminal colours
if [[ -f ~/.local/state/caelestia/sequences.txt ]]; then
    cat ~/.local/state/caelestia/sequences.txt
fi

# ─────────────────────────────────────────────
# Useful aliases
# ─────────────────────────────────────────────

alias l='ls'
alias ll='ls -lah'
alias la='ls -A'
alias cl='clear'
alias scls='clear'
alias copy='wl-copy <'
alias up='ping 1.1.1.1 -c 3'
alias rofi='rofi -show drun'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias cls='clear'

alias grep='grep --color=auto'

alias ins='sudo pacman -S'
alias update='sudo pacman -Syu'
alias rem='sudo pacman -Rns'
alias search='pacman -Ss'
alias installed='pacman -Qs'
alias orphan='pacman -Qdt'

# Typos that happen to the best of us
alias suod='sudo'
alias gerp='grep'
alias chomd='chmod'

# ─────────────────────────────────────────────
# Bash completion
# ─────────────────────────────────────────────

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
fi

# ─────────────────────────────────────────────
# FZF
# ─────────────────────────────────────────────

if command -v fzf &>/dev/null; then
    eval "$(fzf --bash)"
fi

# ─────────────────────────────────────────────
# PATH
# ─────────────────────────────────────────────

[[ -d "$HOME/bin" ]] &&
    export PATH="$HOME/bin:$PATH"

[[ -d "$HOME/.local/bin" ]] &&
    export PATH="$HOME/.local/bin:$PATH"

# ─────────────────────────────────────────────
# Starship
# ─────────────────────────────────────────────

# ble.sh
if [[ -f /usr/share/blesh/ble.sh ]]; then
    source /usr/share/blesh/ble.sh
fi

# Starship
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi
export PATH="$HOME/.local/bin:$PATH"
