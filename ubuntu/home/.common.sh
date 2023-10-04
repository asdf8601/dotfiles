#!/usr/bin/env bash
[ ! -f ~/.bashrc ] && mxm link

export DOTFILES_SRC="$HOME/.dotfiles"
export DOTFILES_HOME="$HOME/.dotfiles"


# variable {{{
export DOCKER_DEFAULT_PLATFORM=linux/amd64
export SSH_KEY_PATH="~/.ssh/rsa_id"
export EDITOR="nvim"

export AUTOENV_ENV_FILENAME=".autoenv"
export AUTOENV_ASSUME_YES=1

export GEM_HOME="$HOME/.gem"
export DEFAULT_IMG=mmngreco/dev:latest
export MYGITPROJECTS="$HOME/github"
export MYVIMRC="$HOME/.config/nvim/init.lua"
export KITTY_LISTEN_ON=unix:/tmp/mykitty-$PPID

# export MOIRA_HOURS_PER_DAY=6
# if not in macos only linux
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


translate_post() {
    file=/tmp/gpt4-translate.md
    sgpt --model gpt-4 --chat blog "translate to english and fix grammar from this markdown: \n\n $(cat $1)" | tee $file
    echo File: $file
}

kx() {
    export KUBECONFIG=$(ls ~/.kube/config* | fzf --height 10 --layout reverse)
}

blog() {
    blog_home="$HOME/github/mmngreco/mmngreco.github.io"
    blog_home="$HOME/github/mmngreco/blog"
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


conda-here () {
    # conda-here [prefix] [*conda-args]
    local prefix="${1:-$PWD/.venv/$(echo $pyver | tr -d = | tr -d .)}"
    local pyver="python=3.7"

    if [ $# -eq 0 ]; then
        conda create --prefix $prefix $pyver pip -y
    else
        conda create --prefix $prefix ${@:2}
    fi

    conda activate "$(abspath $prefix)"

    if [ ! -f ./$AUTOENV_ENV_FILENAME ]; then
        echo conda activate \""$(abspath $prefix)"\" >> $AUTOENV_ENV_FILENAME
        echo $AUTOENV_ENV_FILENAME >> .gitignore
    fi
}


conda-activate() {
    local prefix="$PWD/.venv"
    local selected=$(find $prefix -maxdepth 1 -mindepth 1 -type d | fzf --select-1 --ansi -q "$1" --height 10%)
    conda activate $selected
}

# =============================================================================
# Docker

dfix() {
    # see https://serverfault.com/a/642984/573706
    # sudo apt-get install bridge-utils
    sudo pkill docker
    sudo iptables -t nat -F
    sudo ifconfig docker0 down
    sudo brctl delbr docker0
    sudo service docker restart
}


drun() {

    DIR=$PWD
    IMAGE_NAME=${1:-mmngreco/dev:0.3.2}
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


dclean() {
    docker system prune -a -f
    sudo systemctl stop docker
    sudo systemctl stop docker.socket
    sudo rm -rf /var/lib/docker
    sudo systemctl start docker.socket
    sudo systemctl start docker

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


# txs() {
#     case $1 in
#         com)
#             tmux new-session -d -s com -c ~/gitlab/COM
#             tmux send-keys -t com "txw $2 && clear" Enter
#             tmux attach -t com
#             ;;
#         vpn)
#             tmux new-session -d -s vpn
#             tmux send-keys -t vpn "ets-vpn" Enter
#             ;;
#         gitlab)
#             tmux new-session -d -s "gitlab" -c ~/gitlab
#             tmux send-keys -t gitlab "txw $2 && clear" Enter
#             tmux attach -t gitlab
#             ;;
#         github)
#             tmux new-session -d -s "github" -c ~/github
#             tmux send-keys "txw $2 && clear" Enter
#             tmux attach -t github
#             ;;
#         cancel)
#             ;;
#         *)
#             tmux-sessionizer $1
#             ;;
#     esac
# }
#

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


function jenkinsLint () {
    # https://www.jenkins.io/doc/book/pipeline/development/
    jfile=${1:-Jenkinsfile}
    curl --user "${JENKINS_USER_ID}:${JENKINS_API_TOKEN}" -X POST -F "jenkinsfile=<${jfile}" "${JENKINS_URL}/pipeline-model-converter/validate"
}


function gcloud_bucket_project() {
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


# }}}



# aliases {{{

alias k=kubectl

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
alias clab='PAGER=cat glab'
# alias gcl='git clone'
# alias gst='git status'
# alias gb='git branch'
# alias gco='git checkout'
# alias gob='git checkout -b'
# alias ga='git add'
# alias gc='git commit'
# alias gl='git pull'
# alias gh='git push'
# alias glom='git pull origin master'
# alias ghom='git push origin master'
# alias gg='git grep'
# alias glg='git log --oneline --decorate --graph'

# Output
alias lcase="tr '[:upper:]' '[:lower:]'"
alias ucase="tr '[:lower:]' '[:upper:]'"

# Files
alias lcf="rename 'y/A-Z/a-z/' "
alias ucf="rename 'y/a-z/A-Z/' "

# Tmux
alias tn='tmux set -g mode-mouse on'
alias tf='tmux set -g mode-mouse off'
alias tmux='tmux -2'

# Grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias girn='grep -IRn --color=auto'

# Wget
alias wgetncc='wget --no-check-certificate'

# Utils
alias sitecopy='wget -k -K -E -r -l 10 -p -N -F -nH '
alias ytmp3='youtube-dl --extract-audio --audio-format mp3 '

# docker
# alias dhere="bash ~/gitlab/COM/docker-base/docker_run.sh"
alias dsrm='docker rm $(docker stop $(docker ps -qa))'
alias datt='docker attach'
alias dcb='docker-compose build'
alias dclogs='docker-compose logs'
alias dcu='docker-compose up'
alias ddiff='docker diff'
alias dimg='docker images'
alias dins='docker inspect'
alias dps='docker ps'
alias drm='docker rm'
alias drmi='docker rmi'
# alias drun='docker run'
alias dstart='docker start'
alias dstop='docker stop'
alias dclimg='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
alias drestartf='docker start $(docker ps -ql) && docker attach $(docker ps -ql)'

# ls variants
alias la='ls -A'
alias l='ls -alFtr'
alias lsd='ls -d .*'
alias ll='ls -alF'

# Various
alias h='history | tail'
alias hg='history | grep'
alias mvi='mv -i'
alias rmi='rm -i'
alias ak='ack-grep'

alias gist='xdg-open https://gist.github.com/'
alias sgist="https://gist.github.com/search?q=user%3Ammngreco&ref=simplesearch"


# tmux
alias tks="tmux kill-session"
alias tkill="tmux kill-server"

# RC files
alias trc="nvim ~/.tmux.conf"
alias vrc="nvim ~/.config/nvim/init.lua"
alias zrc="nvim ~/.zshrc"
alias brc="nvim ~/.bashrc"
alias reload="exec $SHELL"

# system
alias sai="sudo apt install"
alias sau="sudo apt update"
alias sag="sudo apt upgrade"
alias sas="sudo apt search"

# conda
alias cc="conda create -n"
alias cel="conda env list"
alias crn="conda remove -n"
alias ca="conda activate"


alias serve="browser-sync start --server --files . --no-notify --port 9000"

# python
alias pyServer='python -s -m http.server'
# alias asdf='setxkbmap -rules evdev -model evdev -layout us -variant dvorak'
alias kb-us='setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl'
alias kb-usnocaps='setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl -option ctrl:nocaps'
alias pipenv='pipx run pipenv'

alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias mic_monitor='gst-launch-1.0 pulsesrc ! pulsesink'

alias ipy=ipython

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
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
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
alias printJson='python -c "from rich import print; import sys; print(sys.stdin.buffer.read())"'
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
addToPathFront "/home/mgreco/.go/bin"
addToPathFront "/usr/local/go/bin"
# db
addToPathFront "/opt/mssql-tools/bin"
addToPath "/opt/mssql-tools/bin"
# ruby
addToPathFront "$GEM_HOME/bin"
# projects folders
addToMyGitProjects $HOME/github
addToMyGitProjects $HOME/gitlab
# }}}

# source {{{
sourcePattern $DOTFILES "*.secret"
sourcePattern $DOTFILES "*.hide"
sourcePattern $DOTFILES_SRC/personal "*.hide"
# }}}

