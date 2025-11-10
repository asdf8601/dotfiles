#!/usr/bin/env zsh
if [ -n "${ZSH_DEBUGRC+1}" ]; then
    # Example:
    # time ZSH_DEBUGRC=1 zsh -i -c exit
    zmodload zsh/zprof
fi


# opencode
export PATH=/home/mgreco/.opencode/bin:$PATH

export DOTFILES=$HOME/.dotfiles/ubuntu
export DOTFILES_HOME=$HOME/.dotfiles
export ZSH=~/.oh-my-zsh
export TAKT_EDITOR=nvim

# variables {{{
export DOTFILES_SRC="$HOME/.dotfiles"
export DOTFILES_HOME="$HOME/.dotfiles"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export SSH_KEY_PATH="~/.ssh/rsa_id"
export EDITOR="nvim"

export AUTOENV_ENV_FILENAME=".autoenv"
export AUTOENV_ASSUME_YES=1

export GEM_HOME="$HOME/.gem"
export DEFAULT_IMG=mmngreco/dev:latest
export MYGITPROJECTS="$HOME/github"
export MYVIMRC="$HOME/.config/nvim/init.lua"
export KITTY_LISTEN_ON=unix:/tmp/mykitty-$PPID

if [[ "$OSTYPE" != "darwin"* ]]; then
    # linux config only
    export CONDA_DIR="$HOME/miniconda3"
    export GDK_BACKEND=x11
    export GTK_THEME=Materia:dark:compact
fi
export AWS_CONFIG_FILE=$HOME/.aws/credentials
# }}}


# hardware {{{
# fast keyboard delay (ms) and speed (keys by sec)
# keyboard typing speed

if [ -x "$(command -v xset)" ]; then
    [ -z ${IS_DOCKER+x} ] && xset r rate 250 60 &> /dev/null
fi

if [ -x "$(command -v setxkbmap)" ]; then
    setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl
fi
# }}}


# functions {{{

function git-br-clean {
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
    prompt="Describe the modifications made as shown in this git diff. Provide a summary of significant changes. Keep the description straightforward and use basic language. Avoid complex terminology."
    branch=${1:-main}
    spgt --model gpt-4o --chat pr "# Prompt\n$prompt\n# Git diff\n$(git diff $branch)"
}

kx() {
    export KUBECONFIG=$(ls ~/.kube/config* | fzf --height 10 --layout reverse)
}

blog() {
    # blog_home="$HOME/github.com/mmngreco/mmngreco.github.io"
    blog_home="$HOME/github.com/mmngreco/blog"
    EDITOR=nvim
    case $1 in
        help)
            echo "Usage: blog <command>"
            echo ""
            echo "Commands:"
            echo "  session  Create a new tmux session"
            echo "  new      Create a new post"
            echo "  serve    Serve the blog"
            echo "  edit     Edit a post"
            ;;
        session)
            # check if tmux server is running
            tmux has-session -t blog && tmux kill-session -t blog
            tmux info &> /dev/null || tmux start-server \; new-session -d
            tmux new-session -s blog -d -c $blog_home
            tmux new-window -a -t blog -c $blog_home
            tmux new-window -a -t blog -c $blog_home

            tmux rename-window -t blog:1 "server"
            tmux rename-window -t blog:2 "edit"
            tmux rename-window -t blog:3 "new"

            tmux send-keys -t blog:edit "blog edit" C-m
            tmux send-keys -t blog:new "blog new" C-m
            tmux send-keys -t blog:server "blog serve" C-m

            window=${2:-new}
            tmux switch-client -t blog:$window || tmux attach-session -t blog:$window
            ;;

        quit)
            tmux kill-session -t blog
            ;;
        new)
            new_post="$(date +"%Y-%m-%d")-post.md"
            file=content/posts/$new_post
            hugo new content posts/$new_post
            $EDITOR $file
            # git add $file
            # git commit -m "enh(content): Add $new_post"
            ;;
        edit)
            file=$(find . -type f | fzf --preview 'bat --color=always {}')
            $EDITOR $file
            # git add $file && git commit -m "enh: update $file"
            ;;
        serve)
            hugo server -D
            ;;
        open)
            open http://localhost:1313 &
            ;;
        *)
            blog session
            ;;
    esac
}

sourcePattern() {
    folder=$1
    pattern=$2
    for hidden in $(find $folder -name $pattern -type f)
    do
        source $hidden
    done
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


recordingScreen() {
    tmux new-session -s recording -d rec_screen
    clear
}

recordingStop() {
    tmux send-keys -t recording:1 C-c
    nautilus $HOME/Videos &
    clear
}


set_rand_wallpaper(){
    find ~/github/mmngreco/wallpapers \
        -type f \
        -not -name "README.md" \
        -not -path "*/.git/*" \
        | shuf -n1\
        | xargs -L1 -I IMG hsetroot -fill IMG
}



pip-lastest() {
    pip install $1==kk |& grep -oP '.*\b\K\d+\.\d+\.\d+\b'
}


ipytdd ()  {
    ipython
    echo "Restarting ipython, press a key to abort."
    read -t 1 cancel
    if [ -z "$cancel" ]
    then
        ipytdd
    fi
}


chown-here () {
    sudo chown -R $USERNAME:$USERNAME ./
}

selectProjectFzf () {
    # Print out the abslute path of every project (which has .git) at HOME dir.
    # query="${1:-tesser}"
    query="${1}"
    listProjects | fzf --select-1 --ansi -q "$query" --height 10% -m --bind "space:toggle"
}


newProject () {
    # find projects using .git folder as reference
    dir=$(listProjectContainers | fzf --select-1 --height 10%)
    prj=$1
    if [ -z $prj ]; then
        echo "Enter project name: "
        read prj
    fi
    mkdir $dir/$prj
    cd $dir/$prj
}

fzfProjects () {
    # Print out the abslute path of every project (which has .git) at HOME dir.
    # query="${1:-tesser}"
    selectProjectFzf $@
}

cdProjects () {
    # Change directory to a project using fzf
    cd $(fzfProjects $@)
}

nvp () {
    # neovim project
    query="${1}"
    fzfProjects $query | xargs -I DIR bash -c "pushd DIR > /dev/null && nvim DIR && popd > /dev/null"
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
# cs () {
#     # cheat sheet
#     url="$(echo cht.sh/$@ | tr ' ' '+')"
#     echo $url
#     curl -s $url
# }

csl () {
    # cheat sheet pipe less
    cs $@ | less
}

function extract_and_remove {
  extract $1
  rm -f $1
}

# function abspath() {
#     if [ -d "$1" ]; then
#         echo "$(cd $1; pwd)"
#     elif [ -f "$1" ]; then
#         if [[ $1 == */* ]]; then
#             echo "$(cd ${1%/*}; pwd)/${1##*/}"
#         else
#             echo "$(pwd)/$1"
#         fi
#     fi
# }
#

function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}


# nq() { d=$(basename "$PWD"); nd=$(printf "../ex%02d*/" $((${d:2:2}+1))); cd $nd ; }

# to go to directory of previous question
# pq() { d=$(basename "$PWD"); pd=$(printf "../ex%02d*/" $((${d:2:2}-1))); cd $pd ; }

# =============================================================================
# Git

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

_gf() {
  # Selects git file
  is_in_git_repo &&
    git -c color.status=always status --short |
    fzf --height 40% -m --ansi --nth 2..,.. | awk '{print $2}'
}

_gb() {
  # Selects git branch
  is_in_git_repo &&
    git branch -a -vv --color=always | grep -v '/HEAD\s' |
    fzf --height 40% --ansi --multi --tac | sed 's/^..//' | awk '{print $1}' |
    sed 's#^remotes/[^/]*/##'
}

_gt() {
  # Selects git tag
  is_in_git_repo &&
    git tag --sort -version:refname |
    fzf --height 40% --multi
}

_gh() {
  # Select git commit from the history
  is_in_git_repo &&
    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph |
    fzf --height 40% --ansi --no-sort --reverse --multi | grep -o '[a-f0-9]\{7,\}'
}

_gr() {
  # Select git remotes
  is_in_git_repo &&
    git remote -v | awk '{print $1 " " $2}' | uniq |
    fzf --height 40% --tac | awk '{print $1}'
}

parse_git_branch () {
    git name-rev HEAD 2> /dev/null | sed 's#HEAD\ \(.*\)# [git:\1]#'
}

parse_svn_branch() {
    parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk -F / '{print " [svn:" $2 "]"}'
}

parse_svn_url() {
    svn info 2>/dev/null | sed -ne 's#^URL: ##p'
}

parse_svn_repository_root() {
    svn info 2>/dev/null | grep -e '^Repository Root:*' | sed -e 's#^Repository Root: *\(.*\)#\1\/#g '
    #svn info 2>/dev/null | sed -ne 's#^Repository Root: ##p'
}

pyright-config-here() {
    cp $DOTFILES/python/pyrightconfig.json .
}

pip-dev-tools() {
    pip install -r $DOTFILES/python/requirements-dev.txt
}

todo() {
    TODO_DEFAULT=${TODO_DEFAULT:-~/MyTODO.md}
    TODO_FILE=${1:-TODO.md}
    [[ -f $TODO_FILE ]] && nvim $TODO_FILE || nvim $TODO_DEFAULT
}


pdbrc-here () {
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
    pushd $1 &> /dev/null \
    && edit $file \
    && popd &> /dev/null
}


takt-git () {
    case $1 in
        push)
            cd $(dirname $TAKT_FILE)
            git add . && git commit -m "$1 $TAKT_FILE" && git push
            ;;
        *)
            takt $@
            cd $(dirname $TAKT_FILE)
            git add . && git commit -m "$1 $TAKT_FILE" && git push
            ;;
    esac
}

# }}}

# aliases {{{

# mail
alias mail-st='neomutt -F ~/.mutt/seedtag.muttrc'
alias mail='neomutt -F ~/.mutt/personal.muttrc'


# kubernets
alias fkpod='kubectl get pods | fzf | awk "{print \$1}" | pbcopy && sleep 0.06 && pbpaste'
alias fklog='fkpod | xargs -I{} kubectl logs {}'
alias klog='kubectl logs'

alias k=kubectl
alias pods='kubectl get pods'

# Files and directories
alias mkdir='mkdir -p -v'

# Navigation
alias back='cd $OLDPWD'
alias home='cd ~/'
alias ..="cd .."
alias ...="cd  ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Editor
alias nano='nano -W -m'
alias edit='nvim'

alias :e='edit'
alias :q='exit'

# Git
alias g=git

# Output
alias lcase="tr '[:upper:]' '[:lower:]'"
alias ucase="tr '[:lower:]' '[:upper:]'"

# Files
alias lcf="rename 'y/A-Z/a-z/' "
alias ucf="rename 'y/a-z/A-Z/' "


# Grep
alias grepe='egrep --color=auto'
alias grepf='fgrep --color=auto'
alias grep='grep --color=auto'
alias girn='grep -IRn --color=auto'

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
alias gist='xdg-open https://gist.github.com/'
alias sgist="https://gist.github.com/search?q=user%3Ammngreco&ref=simplesearch"


# tmux
alias tn='tmux set -g mode-mouse on'
alias tf='tmux set -g mode-mouse off'
alias tmux='tmux -2'
alias t=txs
alias tks="tmux kill-session"
alias tkill="tmux kill-server"

# RC files
alias trc="nvim ~/.tmux.conf +'cd ~/'"
alias vrc="nvim ~/.config/nvim/init.lua +'cd %:h'"
alias zrc="nvim ~/.zshrc +'cd ~/'"
alias brc="nvim ~/.bashrc +'cd ~/'"
alias reload="exec $SHELL"

# system
alias sai="sudo apt install"
alias sau="sudo apt update"
alias sag="sudo apt upgrade"
alias sas="sudo apt search"

alias serve="browser-sync start --server --files . --no-notify --port 9000"

# python
alias ipy=ipython
alias py-server='python -s -m http.server'
# alias asdf='setxkbmap -rules evdev -model evdev -layout us -variant dvorak'
alias kb-us='setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl'
alias kb-usnocaps='setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl -option ctrl:nocaps'
alias pipenv='pipx run pipenv'

# alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"

alias mic_monitor='gst-launch-1.0 pulsesrc ! pulsesink'


# kitty {
alias icat="kitty +kitten icat"
alias s="kitty +kitten ssh"
# }


alias dotcmd='mxm'
alias cd.='. dotcmd cd'

alias snip='pushd_edit_pop ~/github/mmngreco/snippets'
alias scio='pushd_edit_pop ~/github/mmngreco/scio'
alias tasks='grep --exclude-dir=.git -rEIn "TODO|FIXME|XXX|\?\?\?|HACK|BUG" ./**/*.py 2>/dev/null'
alias nvim.='nvim .'

# Linux specific {
if [[ "$OSTYPE" == "linux"* ]]; then
    alias open='xdg-open'
    alias xclip='xclip -selection clipboard'
    alias xclipc='xclip -selection clipboard -o'

    # System
    alias df="df -h"
    alias du="du -h"

    alias easyeffects='flatpak run com.github.wwmm.easyeffects'
    alias fd=fdfind

fi
# }

alias gpt4='sgpt --model gpt-4'
alias gpt4p='sgpt --model gpt-4-1106-preview'
alias echo-json='python -c "from rich import print; import sys; print(sys.stdin.buffer.read())"'
alias echo-print='python -c "from rich import print; import sys; print(sys.stdin.buffer.read())"'
# }}}

# append to path {{{
# bin
addToPath "/usr/local/bin"
addToPath "$HOME/bin"
addToPath "$HOME/.cargo/bin"
addToPath "$HOME/.local/bin"
addToPath "$HOME/.deno/bin"
# go
addToPathFront "$HOME/go/bin"
addToPathFront "/opt/zig"
addToPathFront "/home/mgreco/.go/bin"
addToPathFront "/usr/local/go/bin"
# db
addToPathFront "/opt/mssql-tools/bin"
addToPath "/opt/mssql-tools/bin"
# ruby
addToPathFront "$GEM_HOME/bin"
# nim
addToPathFront "/home/mgreco/.nimble/bin"

# projects folders
addToMyGitProjects $HOME/github.com
addToMyGitProjects $HOME/gitlab.com
addToMyGitProjects $HOME/github
addToMyGitProjects $HOME/gitlab
# }}}

# source {{{
sourcePattern $DOTFILES "*.secret"
sourcePattern $DOTFILES "*.hide"
sourcePattern $DOTFILES_SRC/personal "*.hide"
# }}}


py-here() {
    name=$1
    mkdir -p  ${name}/{tests,docs}
    touch ${name}/{Makefile,pyproject.toml,${name}.py}
    # you can always make the following steps optionals
    curl -sSL https://gist.githubusercontent.com/mmngreco/2a371093fcb704fbff771e39479e75dc/raw/pyproject.toml  | sed "s/\${name}/${name}/g" > ${name}/pyproject.toml
    curl -sSL https://gist.githubusercontent.com/mmngreco/2a371093fcb704fbff771e39479e75dc/raw/Makefile > ${name}/Makefile
    curl -L -s https://www.gitignore.io/api/python > ${name}/.gitignore
    cd ${name} && git init && git add . && git commit -m "add files"
}

wacomfix() {
    xsetwacom set $(xsetwacom list | grep stylus | awk '{print $8}\') MapToOutput "DP-1"
}
function check_run {
    command -v $1 > /dev/null 2>&1 && $2 2> /dev/null
}



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

# if [ -e /home/mgreco/.nix-profile/etc/profile.d/nix.sh ]; then . /home/mgreco/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer


# Created by `pipx` on 2021-12-07 18:17:23
export PATH="$PATH:/home/mgreco/.local/bin"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# command -v pyenv > /dev/null 2>&1 && eval "$(pyenv init -)" 2> /dev/null
check_run pyevn 'eval "$(pyenv init -)"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# source /usr/share/doc/fzf/examples/key-bindings.zsh


# export NVM_LAZY=1
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mgreco/google-cloud-sdk/path.zsh.inc' ]; then . '/home/mgreco/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/mgreco/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/mgreco/google-cloud-sdk/completion.zsh.inc'; fi


# always use US keyboard layout with no capslock (switched to ctrl)
kb-usnocaps


# autoload -Uz compinit
# zstyle ':completion:*' menu select
# fpath+=~/.zfunc

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


alias pjson='python -c "from rich import print; import sys; print(sys.stdin.buffer.read())"'
alias pprint='python -c "from rich import print; import sys; print(sys.stdin.buffer.read())"'
alias zperf='time ZSH_DEBUGRC=1 zsh -i -c exit'

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




if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi
