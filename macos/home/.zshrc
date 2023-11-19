#!/usr/bin/env zsh
export DOTFILES=$HOME/.dotfiles/macos/home
export DOTFILES_HOME=$HOME/.dotfiles
export DOTFILES_UBUNTU=$HOME/.dotfiles/ubuntu

source $DOTFILES_HOME/ubuntu/home/.common.sh
source $DOTFILES/.seedtag
export ZSH=~/.oh-my-zsh

# define always before before sourcing oh-my-zsh.sh
# plugins=(
#     zsh-autosuggestions
# )

# source ~/.zsh/catppuccin-zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh
source $DOTFILES_UBUNTU/home/.prompt.zsh
# export TERM=xterm-kitty

# always after any prompt changes
[ -f $HOME/.autoenv/activate.sh ] && source $HOME/.autoenv/activate.sh
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# === shortcuts {
join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-wrapper() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}
bind-git-wrapper f b t r h s
unset -f bind-git-wrapper
bindkey -s ^t^w "txw\n"
bindkey -s ^t^s "txs\n"
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . /home/mgreco/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
# }

# Created by `pipx` on 2021-12-07 18:17:23 {
export PATH="$PATH:$HOME/.local/bin"
# }

# ==== pyenv {
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv > /dev/null 2>&1 && eval "$(pyenv init -)" 2> /dev/null
# }

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# source /usr/share/doc/fzf/examples/key-bindings.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Created by `pipx` on 2023-11-13 21:27:13
addToPathFront "/Users/mgreco/Library/Python/3.11/bin"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/mgreco/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/mgreco/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/mgreco/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/mgreco/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

