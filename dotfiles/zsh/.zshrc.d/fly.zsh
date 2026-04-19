#!/bin/zsh
#
# fly - Fly.io account tokens
# Set actual values in ~/.config/zsh/.zshrc.local (not tracked)
#

export FLY_TOKEN_PERSONAL=""
export FLY_TOKEN_IC=""

[[ -f "${ZDOTDIR:-$HOME/.config/zsh}/.zshrc.local" ]] && source "${ZDOTDIR:-$HOME/.config/zsh}/.zshrc.local"
