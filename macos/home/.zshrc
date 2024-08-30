#!/usr/bin/env zsh

# conda {{{
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
# }}}


zstyle ':omz:plugins:nvm' lazy yes
export DOTFILES=$HOME/.dotfiles/macos/home
export DOTFILES_HOME=$HOME/.dotfiles
source ~/.common.sh
source $DOTFILES_HOME/personal/.seedtag.hide
export ZSH=~/.oh-my-zsh


# define always before before sourcing oh-my-zsh.sh
# plugins=(
#     zsh-autosuggestions
# )

plugins=(
  nvm
)
# source ~/.zsh/catppuccin-zsh-syntax-highlighting.zsh
export ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh
# source ~/.prompt.zsh
# export TERM=xterm-kitty

# always after any prompt changes
[ -f $HOME/.autoenv/activate.sh ] && source $HOME/.autoenv/activate.sh
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# === shortcuts {{{
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
# }}}

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

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# alias pipx=/Users/mgreco/miniconda3/envs/pipx/bin/pipx


# takt-git() {
#   case $1 in
#     check)
#       takt check
#       cd $(dirname $TAKT_FILE)
#       git add $TAKT_FILE
#       git commit -m "check $(date +%Y-%m-%d)"
#       cd -
#       ;;
#     push)
#       cd $(dirname $TAKT_FILE)
#       git push
#       cd -
#       ;;
#   esac
# }


# alias duckgs="/Users/mgreco/github.com/seedtag/duckgs/.venv/bin/python -m duckgs"
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

addToPath /opt/homebrew/bin
addToPath ~/.local/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/mgreco/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/mgreco/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/mgreco/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/mgreco/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export PATH=$PATH:/Users/mgreco/.pixi/bin

# command -v oh-my-posh >/dev/null && eval "$(oh-my-posh init zsh -c ~/.ohmyposh-config.json)"
command -v mise > /dev/null 2>&1 && eval "$(mise activate zsh)"


addToPath ~/.rye/shims
addToPathFront /opt/homebrew/opt/gnu-sed/libexec/gnubin


alias pyin='source ./.venv/bin/activate'
alias pyout='deactivate'

if [ -f "$HOME/.cargo/env" ]; then . "$HOME/.cargo/env"; fi
