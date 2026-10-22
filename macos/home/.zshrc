#!/usr/bin/env zsh

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    # Example:
    # time ZSH_DEBUGRC=1 zsh -i -c exit
    zmodload zsh/zprof
fi

# keep PATH entries unique across nested shells
typeset -U path PATH

export MYGITPROJECTS="$HOME/github.com:$HOME/gitlab.com"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openblas/lib/pkgconfig"
#
export PIP_REQUIRE_VIRTUALENV=true
#
export GEM_HOME="$HOME/.gem"
export MYVIMRC="$HOME/.config/nvim/init.lua"
export KITTY_LISTEN_ON=unix:/tmp/mykitty-$PPID
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$HOME/go/bin:$HOME/.go/bin:/usr/local/go/bin:/opt/mssql-tools/bin:$GEM_HOME/bin:$PATH:/usr/local/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin"

# Prompts {{{
# export PS1="%F{magenta}%n%f@%F{green}%M%f:%F{cyan}%~%f %F{magenta}(%T)%f %F{green}\$%f "
# export PS1="%F{magenta}%n%f@%F{green}%m%f:%F{cyan}%1d%f %F{magenta}(%D{%L:%M:%S})%f %F{green}\$%f "
# export PS1="%F{cyan}%1d%f %F{magenta}(%D{%X})%f %F{green}\$%f "
# export PS1="%F{cyan}%~%f %F{magenta}(%D{%H:%M})%f %F{green}\$%f "
export PS1="%F{cyan}%~%f %F{magenta}(%D{%H:%M})%f"$'\n'"%F{green}\$%f "

setps() {
    case $1 in
        1)
            # $
            export PS1="%F{green}\$%f "
        ;;
        2)
            # ~ (09:37)
            # $
            export PS1="%F{cyan}%~%f %F{magenta}(%D{%H:%M})%f"$'\n'"%F{green}\$%f "
        ;;
        *)
            # ~ (09:37) $
            export PS1="%F{cyan}%~%f %F{magenta}(%D{%H:%M})%f %F{green}\$%f "
        ;;
    esac
}

# }}}


# hardware {{{
# fast keyboard delay (ms) and speed (keys by sec)
# keyboard typing speed
# if [ -x "$(command -v xset)" ]; then
#     echo "Setting keyboard repeat rate with xset"
#     [ -z ${IS_DOCKER+x} ] && xset r rate 250 60 &> /dev/null
# fi

# if [[ "$OSTYPE" == "darwin"* ]]; then
#     echo "Setting keyboard layout for macOS"
#     defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
# fi
# }}}


function venv() {
    if [[ -n "${VIRTUAL_ENV:+x}" ]]; then
        if type deactivate &>/dev/null; then
            deactivate
            echo "Virtual environment deactivated"
        else
            echo "deactivate function not found, but VIRTUAL_ENV is set"
            unset VIRTUAL_ENV
            echo "VIRTUAL_ENV variable unset"
        fi
    else
        if [[ -d ./.venv ]]; then
            source ./.venv/bin/activate
            echo "Virtual environment activated"
        else
            echo "No .venv directory found in current directory"
        fi
    fi
}


# aliases {{{

alias erc='nvim ~/.config/espanso/match/base.yml'
alias dk='deepseek'

alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'


# kubernets
alias hadolint='docker run --rm -i hadolint/hadolint < '
alias k=kubectl
alias pods='kubectl get pods'
alias k-pod='kubectl get pods | fzf | awk "{print \$1}" | pbcopy && sleep 0.05 && pbpaste'
alias k-service='kubectl get services | fzf | awk "{print \$1}" | pbcopy && sleep 0.05 && pbpaste'
alias k-deployment='kubectl get deployments | fzf | awk "{print \$1}" | pbcopy && sleep 0.05 && pbpaste'
alias k-hpa='kubectl get hpa | fzf | awk "{print \$1}" | pbcopy && sleep 0.05 && pbpaste'
alias k-exec='kubectl exec -it $(pbpaste) -- bash'
alias k-log='kubectl logs $(pbpaste) -f'

function k-debug() {
    local pod=$(kubectl get pods --all-namespaces -o wide | fzf --header-lines=1 | awk '{print $2, $1}')
    local pod_name=$(echo $pod | awk '{print $1}')
    local namespace=$(echo $pod | awk '{print $2}')
    local target=$(kubectl get pod $pod_name -n $namespace -o jsonpath='{.spec.containers[0].name}')
    if [ -n "$pod_name" ]; then
        kubectl debug $pod_name -n $namespace -ti --image=nicolaka/netshoot --target=$target --profile=sysadmin
    fi
}

# Files and directories
alias mkdir='mkdir -p -v'

# Navigation
alias back='cd $OLDPWD'
alias home='cd ~/'
alias ..="cd .."
alias ...="cd  ../.."

# Editor
alias edit='nvim'

alias :e='edit'
alias :q='exit'

# Git
alias g=git
alias g.='git here'


# Output
alias lcase="tr '[:upper:]' '[:lower:]'"
alias ucase="tr '[:lower:]' '[:upper:]'"

# Files
alias lcf="rename 'y/A-Z/a-z/' "
alias ucf="rename 'y/a-z/A-Z/' "


# Grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias grin='grep -IRn --color=auto'

# Wget
alias wgetncc='wget --no-check-certificate'

# Utils
alias sitecopy='wget -k -K -E -r -l 10 -p -N -F -nH '
alias ytmp3='youtube-dl --extract-audio --audio-format mp3 '

# ls variants
alias la='ls -A'
alias l='ls -alFtr'
alias lsd='ls -d .*'
alias ll='ls -alF'

# github.com
alias gist='open https://gist.github.com/'
alias sgist="https://gist.github.com/search?q=user%3Aasdf8601&ref=simplesearch"


# tmux
alias tmux='tmux -2'
alias ta='tmux a'
alias t=txs
alias tkill="tmux kill-server"

# RC files
alias trc="nvim ~/.tmux.conf +'cd ~/'"
alias vrc="nvim ~/.config/nvim/init.lua +'cd %:h'"
alias zrc="nvim ~/.zshrc +'cd ~/'"
alias brc="nvim ~/.bashrc +'cd ~/'"
alias reload="exec $SHELL"

alias serve="browser-sync start --server --files . --no-notify --port 9000"

# python
alias ipy=ipython
alias py-server='python -s -m http.server'



alias dotcmd='mxm'

alias snip='pushd_edit_pop ~/github.com/asdf8601/snippets'
alias scio='pushd_edit_pop ~/github.com/asdf8601/scio'
alias nvim.='nvim .'
alias nivm.='nvim .'

alias pjson='python -c "from rich import print; import sys; print(sys.stdin.buffer.read())"'
alias pprint='python -c "from rich import print; import sys; print(sys.stdin.buffer.read())"'
alias blog-monthly='uv run https://gist.githubusercontent.com/asdf8601/60e05c74cd3906a1985b7e78a2224871/raw/rss-monthly.py'
alias zperf='time ZSH_DEBUGRC=1 zsh -i -c exit'
# }}}


## functions {{{
tasks() {
    ext=${1:-py}
    if command -v rg &> /dev/null; then
        rg --hidden -g "*.$ext" "TODO:|FIXME:|XXX:|\?\?\?:|HACK:|BUG:" . 2>/dev/null
    else
        grep --exclude-dir=.git -rEIn "TODO:|FIXME:|XXX:|\?\?\?:|HACK:|BUG:" ./**/*.$ext 2>/dev/null
    fi
}


py-new() {
    # create a python project skeleton
    name=$1
    mkdir -p  ${name}/{tests,docs}
    touch ${name}/{Makefile,pyproject.toml,${name}.py}
    # you can always make the following steps optionals
    curl -sSL https://gist.githubusercontent.com/asdf8601/2a371093fcb704fbff771e39479e75dc/raw/pyproject.toml | sed "s/\${name}/${name}/g" > ${name}/pyproject.toml
    curl -sSL https://gist.githubusercontent.com/asdf8601/2a371093fcb704fbff771e39479e75dc/raw/Makefile > ${name}/Makefile
    curl -L -s https://www.gitignore.io/api/python > ${name}/.gitignore
    cd ${name} && git init && git add . && git commit -m "add files"
}


mkcd-vim() {
    # mkcd-vim folder file
    # mcv folder file
    folder=$1
    file=$2
    mkdir -p $folder
    cd $folder
    nvim $file
}

# gpt {{{

git-br-clean() {
    git fetch -p origin
    git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -d
}

gpt-trad-md() {
    file=/tmp/gpt4-translate.md
    sgpt --model gpt-4o --chat blog "translate to english and fix grammar from this markdown: \n\n $(cat $1)" | tee $file
    echo "File: $file"
}

gpcode() {
    echo $@ | sgpt --code --model gpt-4o
}

gpt() {
    echo $@ | sgpt --model=gpt-4o
}

gpt-pr() {
    prompt=''
    branch="${1:-main}"
    altbr="${2:-master}"
    git_diff_output="$(printf '%s\n' $(git diff $branch || git diff $altbr))"
    echo $git_diff_output
    prompt="$(printf '# Prompt\n%s\n# Git diff\n%s\n' "$prompt" "$git_diff_output")"
    echo $prompt
    sgpt --model gpt-4o --chat pr "$prompt"
}
# }}}


nvimrc () {
  cd $HOME/.config/nvim && \
  git commit -am "${1:-automatic commit}" && \
  git push && \
  cd -
}


calcpy () {
  python -c "from math import *; print(f'{$@:,.2f}')"
}


pyvenv () {
  python${2:-3} -m venv ${1:-.venv}
}


# functions {{{

kx() {
    export KUBECONFIG=$(ls ~/.kube/config* | fzf --height 10 --layout reverse)
}


addToMyGitProjects(){
    if [[ "$MYGITPROJECTS" != *"$1"*  ]]; then
        # only if exists the folder it will be exported
        [ -d "$1" ] && export MYGITPROJECTS="$MYGITPROJECTS:$1"
    fi
}

addToPath(){
    if [[ "$PATH" != *"$1"*  ]]; then
        export PATH="$PATH:$1"
    fi
}

addToPathFront(){
    if [[ "$PATH" != *"$1"*  ]]; then
        export PATH="$1:$PATH"
    fi
}


ipytdd ()  {
    ipython
    echo "Restarting ipython, press a key to abort."
    unset cancel
    read -t 1 cancel
    if [ -z "$cancel" ]
    then
        ipytdd
    fi
}
# }}

# =============================================================================
# Docker {{

drun() {

    DIR=$PWD
    IMAGE_NAME=${1:-asdf8601/dev:0.3.2}
    echo Container name:
    echo $CONTAINER_NAME

    docker run \
        --rm \
        --network host \
        --env TERM="xterm-256color" \
        --env "DOTFILES=/root/.dotfiles" \
        --volume "$HOME/.config/gcloud/:/root/.config/gcloud" \
        --volume "$HOME/.config/gspread/:/root/.config/gspread" \
        --volume "$HOME/.ssh:/root/.ssh" \
        --volume "$DIR:/root/$(basename $DIR)" \
        --volume "$DOTFILES:/root/.dotfiles" \
        --volume "$HOME/.common.sh:/root/.common.sh" \
        --volume "$HOME/.prompt.sh:/root/.prompt.sh" \
        --volume "$HOME/.prompt.zsh:/root/.prompt.zsh" \
        --volume "$HOME/.bashrc:/root/.bashrc" \
        --volume "$HOME/.zshrc:/root/.zshrc" \
        --workdir "/root/$(basename $DIR)" \
        --name "$CONTAINER_NAME" \
        --interactive \
        --tty \
        "$IMAGE_NAME" \
        $2
}


export DEFAULT_IMG=asdf8601/dev:latest

ddev() {
    # reusing a docker container
    DIR=$PWD
    IMAGE_NAME=${1:-$DEFAULT_IMG}
    SUFFIX="${2:-dev}"
    CONTAINER_NAME="$(basename $DIR)-$(echo $SUFFIX | tr -d .)"
    if [ "$(docker ps -a -q -f name=$CONTAINER_NAME)" ]
    then
        echo "Attaching the container $CONTAINER_NAME"
        docker stop $CONTAINER_NAME
        docker start -ia $CONTAINER_NAME
    else
        echo "Creating the container..."
        docker run \
            --env TERM="xterm-256color" \
            --volume "$HOME/.ssh:/root/.ssh" \
            --volume "$DIR:/git/$(basename $DIR)" \
            --workdir "/git/$(basename $DIR)" \
            --name "$CONTAINER_NAME" \
            --interactive \
            --tty \
            "$IMAGE_NAME"
    fi

}
# }}

chown-here () {
    sudo chown -R $USERNAME:$USERNAME ./
}

selectProjectFzf () {
    # Print out the abslute path of every project (which has .git) at HOME dir.
    # query="${1:-tesser}"
    query="${1}"
    listProjectContainers | fzf --select-1 --ansi -q "$query" --height 10% -m --bind "space:toggle"
}


newProject () {
    # find projects using .git folder as reference
    local dir=$(listProjectContainers | fzf --select-1 --height 10%)
    local prj=$1
    if [ -z "$prj" ]; then
        echo -n "Enter project name: "
        read prj
    fi
    mkdir -p $dir/$prj
    echo $dir/$prj
}

lsps () {
    # Print out the abslute path of every project (which has .git) at HOME dir.
    # query="${1:-tesser}"
    listProjects | fzf --select-1 --ansi --height 10% -q "$1"
}

mkps () {
    # make project
    # create a new project using fzf
    # and open it in nvim
    local dir=$(listProjectContainers | fzf --select-1 --height 10%)
    local prj=$1
    if [ -z "$prj" ]; then
        echo -n "Enter project name: "
        read prj
    fi
    mkdir -p $dir/$prj
    cd $dir/$prj
    nvim .
}

cdps () {
    # Change directory to a project using fzf
    cd $(lsps $@)
}

edps () {
    # edit project
    # neovim project
    query="${1}"
    lsps $query | xargs -I DIR bash -c "pushd DIR > /dev/null && nvim DIR && popd > /dev/null"
}


txw() {

    if [[ -z "$@" ]]
    then
        # no arguments
        folder_query="${1}"
        selectProjectFzf $folder_query \
            | xargs -L1 -I FOLDER bash -c "tmux new-window -c FOLDER"
    else
        # when arguments are passed
        for folder_query in $@
        do
            selectProjectFzf $folder_query \
                | xargs -L1 -I FOLDER bash -c "tmux new-window -c FOLDER"
        done
    fi
}


# =============================================================================
# cheat sheet
csl () {
    # cheat sheet pipe less
    chsl $@ | less
}

extract_and_remove() {
  extract $1
  rm -f $1
}

gi() { curl -L -s https://www.gitignore.io/api/$@ ;}


# =============================================================================
# Git

pyrightrc() {
    cp $DOTFILES/python/pyrightconfig.json .
}

pip-rdev() {
    pip install -r $DOTFILES/python/requirements-dev.txt
}


todo() {
    TODO_DEFAULT=${TODO_DEFAULT:-~/MyTODO.md}
    TODO_FILE=${1:-TODO.md}
    [[ -f $TODO_FILE ]] && nvim $TODO_FILE || nvim $TODO_DEFAULT
}


pdbrc () {
    echo "# b $PWD/src/file.py:lineno, condition" > .pdbrc
}


jenkinsLint () {
    # https://www.jenkins.io/doc/book/pipeline/development/
    jfile=${1:-Jenkinsfile}
    curl --user "${JENKINS_USER_ID}:${JENKINS_API_TOKEN}" -X POST -F "jenkinsfile=<${jfile}" "${JENKINS_URL}/pipeline-model-converter/validate"
}


gcloud_bucket_project() {
	BUCKET_NAME=$1
	PROJECT_NUMBER=$(curl -X GET \
	-H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
	"https://storage.googleapis.com/storage/v1/b/${BUCKET_NAME}?fields=projectNumber" | jq .projectNumber | sed 's/"//' | sed 's/"//')
	gcloud projects list --filter "PROJECT_NUMBER=${PROJECT_NUMBER}"
}


pushd_edit_pop () {
    # Move to a directory $1
    # edit a file $2
    # return to the original directory
    file="${2:-.}"
    pushd $1 &> /dev/null  && edit $file && popd &> /dev/null
}


# }}}


# source {{{
export DOTFILES_SRC=$HOME/.dotfiles
export DOTFILES_HOME=$HOME/.dotfiles
export DOTFILES_ROOT=$HOME/.dotfiles

# API tokens live in one login-keychain item (service "dotfiles", account
# "env") as base64 NAME=value lines. Only the first shell pays the ~20ms
# lookup; shells that inherit DOTFILES_SECRETS skip it.
if [[ -z ${DOTFILES_SECRETS:-} ]]; then
    () {
        local blob line
        blob=$(security find-generic-password -s dotfiles -a env -w 2>/dev/null | base64 -d 2>/dev/null)
        [[ -n $blob ]] || return
        for line in ${(f)blob}; do
            [[ $line == [A-Za-z_]*=* ]] && export "$line"
        done
        export DOTFILES_SECRETS=1
    }
fi

secrets-edit() {
    # edit the keychain secrets in $EDITOR; shells already open keep the old values
    local tmp
    tmp=$(mktemp) || return
    security find-generic-password -s dotfiles -a env -w | base64 -d > $tmp
    ${EDITOR:-nvim} $tmp
    print -r -- "add-generic-password -U -s dotfiles -a env -w $(base64 < $tmp | tr -d '\n')" | security -i
    rm -f $tmp
}

secrets-set() {
    # add or replace one keychain secret and export it in this shell; the value
    # is read without echo and never passed as an argument to a command
    local name=$1 value blob
    local -a lines
    if [[ ! $name =~ '^[A-Za-z_][A-Za-z0-9_]*$' ]]; then
        print -u2 "usage: secrets-set NAME"
        return 2
    fi
    read -rs "value?$name: "
    print
    [[ -n $value ]] || return 1
    blob=$(security find-generic-password -s dotfiles -a env -w 2>/dev/null | base64 -d 2>/dev/null)
    lines=(${(f)blob})
    lines=(${lines:#$name=*} "$name=$value")
    print -r -- "add-generic-password -U -s dotfiles -a env -w $(print -r -- ${(F)lines} | base64 | tr -d '\n')" | security -i || return
    export "$name=$value"
}

source $DOTFILES_SRC/personal/.custom.hide
source $DOTFILES_SRC/personal/.seedtag.hide
# }}}

# plugins=()
# source $ZSH/oh-my-zsh.sh

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi


eval "$(direnv hook zsh)"
source ~/.fzf.zsh

# source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh


alias espanso='EDITOR=nvim espanso'
alias opencode='EDITOR=nvim opencode'

# Run gh with its own stored auth; the subshell keeps GH_TOKEN for everything else.
gh () (
    unset GH_TOKEN GITHUB_TOKEN
    command gh "$@"
)

# opencode
export PATH=/Users/mgreco/.opencode/bin:$PATH

# restish is a command-line tool for interacting with REST APIs.
alias restish="noglob restish"
function cd.() {
  local query="$@"
  local selected_dir

  if [ -z "$query" ]; then
    # If no argument, behave like the original interactive fzf
    selected_dir=$(find . -maxdepth 4 -type d | fzf --height 10%)
  else
    # If argument, use it as query and automatically select the best match
    selected_dir=$(find . -maxdepth 4 -type d | fzf --height 10% --select-1 --exit-0 -q "$query")
  fi

  if [ -n "$selected_dir" ]; then
    cd "$selected_dir"
  else
    if [ -n "$query" ]; then
      echo "No directory found matching '$query'."
    else
      echo "No directory selected."
    fi
  fi
}

alias geminiflash='llm -m github_copilot/gemini-3.8-flash -o temperature 0'
alias gpt6='llm -m github_copilot/gpt-6.1-sol -o temperature 0'
alias sonnet='llm -m github_copilot/claude-sonnet-5.5 -o temperature 0'


function ai() {
  python3 - "$@" <<'PY'
import argparse, os, shlex, sys

parser = argparse.ArgumentParser(prog="ai")
parser.add_argument("-m","--model", default="github_copilot/claude-sonnet-5.5")
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


# test container -- podman compatible
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
export TESTCONTAINERS_RYUK_DISABLED=true
# go: version per project via go.mod toolchain directive
export GOTOOLCHAIN=auto
# go builds and runs binaries here instead of the macOS per-user TMPDIR
export GOTMPDIR=$HOME/.cache/go-tmp
[[ -d $GOTMPDIR ]] || mkdir -p $GOTMPDIR

# completion: skip the compaudit security check except once a day
autoload -Uz compinit
_zcompdump_stale=(${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24))
if (( $#_zcompdump_stale )); then
    compinit && touch ${ZDOTDIR:-$HOME}/.zcompdump
else
    compinit -C
fi
unset _zcompdump_stale

# bun completions
[ -s "/Users/mgreco/.oh-my-zsh/completions/_bun" ] && source "/Users/mgreco/.oh-my-zsh/completions/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"



export PATH=$PATH:$HOME/.local/opt/go/bin

# podman puts its API socket under the TMPDIR the machine started with, so
# read the path from a cache and refresh it in the background
_podman_host_cache=$HOME/.cache/podman-docker-host
[[ -s $_podman_host_cache ]] && export DOCKER_HOST=$(<$_podman_host_cache)
(
    sock=$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' 2>/dev/null) \
        && [[ -n $sock ]] && print -r -- "unix://$sock" >| $_podman_host_cache
) &!

export PATH=$PATH:$HOME/github.com/seedtag/adx-ohmyagent
# export UV_EXCLUDE_NEWER='30 days'

alias oc=opencode
alias ocrc='nvim ~/.config/opencode/'
alias cc=ccr

# Skip npm/yarn/pnpm lifecycle scripts
export NPM_CONFIG_IGNORE_SCRIPTS=true
export YARN_ENABLE_SCRIPTS=false
export NPM_CONFIG_MINIMUM_RELEASE_AGE=7200


# Added by Antigravity CLI installer
export PATH="/Users/mgreco/.local/bin:$PATH"

# kimi-code
export PATH="/Users/mgreco/.kimi-code/bin:$PATH"

# Qwen Code PATH block begin
export PATH='/Users/mgreco/.local/bin':$PATH
# Qwen Code PATH block end

# pnpm
export PNPM_HOME='/Users/mgreco/Library/pnpm'
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
