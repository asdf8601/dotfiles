#!/usr/bin/env bash

source ~/.common.sh
source ~/.prompt.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# always after any prompt changes
[ -f $HOME/.autoenv/activate.sh ] && source $HOME/.autoenv/activate.sh

# Prompt
eval "$(starship init bash)"

. "$HOME/.atuin/bin/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"
. "$HOME/.cargo/env"
