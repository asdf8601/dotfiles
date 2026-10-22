#!/usr/bin/env bash




source ~/.common.sh
source ~/.prompt.sh

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# always after any prompt changes
command -v direnv &>/dev/null && eval "$(direnv hook bash)"

# Prompt
eval "$(starship init bash)"

. "$HOME/.atuin/bin/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"
. "$HOME/.cargo/env"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"





# Added by Antigravity CLI installer
export PATH="/Users/mgreco/.local/bin:$PATH"
