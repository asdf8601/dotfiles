#!/usr/bin/env zsh
export DOTFILES=$HOME/.dotfiles/ubuntu
export DOTFILES_HOME=$HOME/.dotfiles
source ~/.common.sh
export ZSH=~/.oh-my-zsh
export TAKT_EDITOR=nvim

function check_run {
    command -v $1 > /dev/null 2>&1 && $2 2> /dev/null
}

# define always before before sourcing oh-my-zsh.sh
# plugins=(
#     zsh-autosuggestions
# )

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mgreco/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/mgreco/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/mgreco/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/mgreco/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# source ~/.zsh/catppuccin-zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh
source ~/.prompt.zsh


# always after any prompt changes
[ -f $HOME/.autoenv/activate.sh ] && source $HOME/.autoenv/activate.sh
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# ----------------------------------------------------------------------------
# >>> shortcuts >>> {{
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
# <<< shortcuts <<<
# }}

if [ -e /home/mgreco/.nix-profile/etc/profile.d/nix.sh ]; then . /home/mgreco/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer


# Created by `pipx` on 2021-12-07 18:17:23
export PATH="$PATH:/home/mgreco/.local/bin"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# command -v pyenv > /dev/null 2>&1 && eval "$(pyenv init -)" 2> /dev/null
check_run pyevn 'eval "$(pyenv init -)"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# source /usr/share/doc/fzf/examples/key-bindings.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mgreco/google-cloud-sdk/path.zsh.inc' ]; then . '/home/mgreco/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/mgreco/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/mgreco/google-cloud-sdk/completion.zsh.inc'; fi


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# always use US keyboard layout with no capslock (switched to ctrl)
kb-usnocaps


autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

check_run mise 'eval "$(~/.local/bin/mise activate zsh)"'
# command -v mise > /dev/null 2>&1 && eval "$(~/.local/bin/mise activate zsh)" 2> /dev/null

alias pyin='source ./.venv/bin/activate'
alias pyout='deactivate'

if [ -f "$HOME/.cargo/env" ]; then . "$HOME/.cargo/env"; fi

function nvim-camp {
  cd $HOME/.config/nvim && \
  git commit -am "${1:-automatic commit}" && \
  git push && \
  cd -
}

function lsps () {
    # Print out the abslute path of every project (which has .git) at HOME dir.
    # query="${1:-tesser}"
    listProjects | fzf --select-1 --ansi --height 10% -q "$1"
}

function cdps () {
    # Change directory to a project using fzf
    cd $(lsps $@)
}

# opencode
export PATH=/Users/mgreco/.opencode/bin:$PATH

# restish is a command-line tool for interacting with REST APIs.
alias restish="noglob restish"
alias cd.='cd $(find . -maxdepth 4 -type d | fzf --height 10%)'

alias geminipro='llm -m github_copilot/gemini-2.5-pro -o temperature 0'
alias geminiflash='llm -m github_copilot/gemini-2.0-flash-001 -o temperature 0'
alias gpt5='llm -m github_copilot/gpt-5 -o temperature 0'
alias sonnet='llm -m github_copilot/claude-4-sonnet -o temperature 0'
alias sonnett='llm -m github_copilot/claude-3.7-sonnet-thought -o temperature 0'


function ai() {
  python3 - "$@" <<'PY'
import argparse, os, shlex, sys

parser = argparse.ArgumentParser(prog="ai")
parser.add_argument("-m","--model", default="github_copilot/gemini-2.5-pro")
parser.add_argument("-o","--option", nargs=2, action="append", default=[], metavar=("KEY","VALUE"))
parser.add_argument("-q","--query", required=True)
parser.add_argument("--dry-run", action="store_true")
args = parser.parse_args()

kv = [("temperature","0"), ("max_tokens","1024")]

for k, v in (args.option or []):
    kv = [(kk, vv) for kk, vv in kv if kk != k] + [(k, str(v))]

cmd = ["llm", "-m", args.model]
for k, v in kv:
    cmd += ["-o", k, v]
cmd += [args.query]

if args.dry_run:
    print(" ".join(shlex.quote(c) for c in cmd))
    sys.exit(0)

os.execvp(cmd[0], cmd)
PY
}

# opencode
export PATH=/home/mgreco/.opencode/bin:$PATH
