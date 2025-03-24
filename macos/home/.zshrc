#!/usr/bin/env zsh

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    # Example:
    # time ZSH_DEBUGRC=1 zsh -i -c exit
    zmodload zsh/zprof
fi

# variables {{{
export MYGITPROJECTS="$HOME/github.com:$HOME/gitlab.com"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openblas/lib/pkgconfig"


export DOTFILES_SRC="$HOME/.dotfiles"
export DOTFILES_HOME="$HOME/.dotfiles"
#
export PIP_REQUIRE_VIRTUALENV=true
export DOTFILES_ROOT=$HOME/.dotfiles
#
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$HOME/go/bin:$HOME/.go/bin:/usr/local/go/bin:/opt/mssql-tools/bin:$GEM_HOME/bin:$PATH:/usr/local/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin"
export SSH_KEY_PATH="~/.ssh/rsa_id"

export AUTOENV_ENV_FILENAME=".autoenv"
export AUTOENV_ASSUME_YES=1

export GEM_HOME="$HOME/.gem"
export DEFAULT_IMG=asdf8601/dev:latest
export MYGITPROJECTS="$HOME/github.com:$HOME/gitlab.com"
export MYVIMRC="$HOME/.config/nvim/init.lua"
export KITTY_LISTEN_ON=unix:/tmp/mykitty-$PPID

export AWS_CONFIG_FILE=$HOME/.aws/credentials

# Prompt
# export PS1="%F{magenta}%n%f@%F{green}%M%f:%F{cyan}%~%f %F{magenta}(%T)%f %F{green}\$%f "
# export PS1="%F{magenta}%n%f@%F{green}%m%f:%F{cyan}%1d%f %F{magenta}(%D{%L:%M:%S})%f %F{green}\$%f "
export PS1="%F{cyan}%1d%f %F{magenta}(%D{%X})%f %F{green}\$%f "


# }}}


# hardware {{{
# fast keyboard delay (ms) and speed (keys by sec)
# keyboard typing speed
if [ -x "$(command -v xset)" ]; then
    echo "xset"
    [ -z ${IS_DOCKER+x} ] && xset r rate 250 60 &> /dev/null
fi

if [ -x "$(command -v setxkbmap)" ]; then
    echo "setxbmap"
    setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl
fi
# }}}



# aliases {{{

alias erc='nvim ~/.config/espanso/match/base.yml'
alias dk='deepseek'
alias pyin='source ./.venv/bin/activate'
alias pyout='deactivate'

alias hadolint='docker run --rm -i hadolint/hadolint < '

# kubernets
alias k=kubectl
alias pods='kubectl get pods'
alias k-pod='kubectl get pods | fzf | awk "{print \$1}" | pbcopy && sleep 0.05 && pbpaste'
alias k-service='kubectl get services | fzf | awk "{print \$1}" | pbcopy && sleep 0.05 && pbpaste'
alias k-deployment='kubectl get deployments | fzf | awk "{print \$1}" | pbcopy && sleep 0.05 && pbpaste'
alias k-hpa='kubectl get hpa | fzf | awk "{print \$1}" | pbcopy && sleep 0.05 && pbpaste'
alias k-exec='kubectl exec -it $(pbpaste) -- bash'
alias k-log='kubectl logs $(pbpaste) -f'

# Files and directories
alias mkdir='mkdir -p -v'

# Navigation
alias back='cd $OLDPWD'
alias home='cd ~/'
alias ..="cd .."
alias ...="cd  ../.."
# alias ....="cd ../../.."
# alias .....="cd ../../../.."
# alias ......="cd ../../../../.."

# Editor
# alias nano='nano -W -m'
alias edit='nvim'

alias :e='edit'
alias :q='exit'

# Git
alias g=git

# alias clab='PAGER=cat glab'
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

# docker
# alias dhere="bash ~/gitlab/COM/docker-base/docker_run.sh"
# alias dsrm='docker rm $(docker stop $(docker ps -qa))'
# alias datt='docker attach'
# alias dcb='docker-compose build'
# alias dclogs='docker-compose logs'
# alias dcu='docker-compose up'
# alias ddiff='docker diff'
# alias dimg='docker images'
# alias dins='docker inspect'
# alias dps='docker ps'
# alias drm='docker rm'
# alias drmi='docker rmi'
# alias drun='docker run'
# alias dstart='docker start'
# alias dstop='docker stop'
# alias dclimg='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
# alias drestartf='docker start $(docker ps -ql) && docker attach $(docker ps -ql)'

# ls variants
alias la='ls -A'
alias l='ls -alFtr'
alias lsd='ls -d .*'
alias ll='ls -alF'

# Various
# alias h='history | tail'
# alias hg='history | grep'
# alias mvi='mv -i'
# alias rmi='rm -i'
# alias ak='ack-grep'

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
# alias asdf='setxkbmap -rules evdev -model evdev -layout us -variant dvorak'
alias kb-us='setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl'
alias kb-usnocaps='setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl -option ctrl:nocaps'
alias pipenv='pipx run pipenv'

# alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
alias mic_monitor='gst-launch-1.0 pulsesrc ! pulsesink'


# kitty {{{{
# alias icat="kitty +kitten icat"
# alias s="kitty +kitten ssh"
# }}}


alias dotcmd='mxm'
alias cd.='. dotcmd cd'

alias snip='pushd_edit_pop ~/github/asdf8601/snippets'
alias scio='pushd_edit_pop ~/github/asdf8601/scio'
alias nvim.='nvim .'
alias nivm.='nvim .'

# alias gpt4='sgpt --model gpt-4'
# alias gpt4p='sgpt --model gpt-4-1106-preview'
alias echo-json='python -c "from rich import print; import sys; print(sys.stdin.buffer.read())"'
alias echo-print='python -c "from rich import print; import sys; print(sys.stdin.buffer.read())"'
alias blog-monthly='uv run https://gist.githubusercontent.com/asdf8601/60e05c74cd3906a1985b7e78a2224871/raw/rss-monthly.py'
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


pprint() {
    echo $@ | python -c "import sys; print(eval(sys.stdin.buffer.read()))"
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

git-br-clean() {
    git fetch -p origin
    git branch -vv | grep 'origin/.*: gone]' | awk '{print $1}' | xargs git branch -d
}

gpt-trad-md() {
    file=/tmp/gpt4-translate.md
    sgpt --model gpt-4-1106-preview --chat blog "translate to english and fix grammar from this markdown: \n\n $(cat $1)" | tee $file
    echo "File: $file"
}

kx() {
    export KUBECONFIG=$(ls ~/.kube/config* | fzf --height 10 --layout reverse)
}

blog() {
    # blog_home="$HOME/github.com/asdf8601/asdf8601.github.io"
    blog_home="$HOME/github.com/asdf8601/blog"
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
            cd $blog_home
            if [ -n "$2" ]; then
                new_post=$2
            else
                new_post="$(date +"%Y-%m-%d")-post.md"
            fi
            hugo new content posts/$new_post
            file=$blog_home/content/posts/$new_post
            $EDITOR $file
            git add $file
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

# sourcePattern() {
#     folder=$1
#     pattern=$2
#     for hidden in $(find $folder -name $pattern -type f)
#     do
#         source $hidden
#     done
# }

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
    find ~/github.com/asdf8601/wallpapers \
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
# cs () {
#     # cheat sheet
#     url="$(echo cht.sh/$@ | tr ' ' '+')"
#     echo $url
#     curl -s $url
# }

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

pyright-here() {
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
    pushd $1 &> /dev/null  && edit $file && popd &> /dev/null
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


# source {{{
source $DOTFILES_SRC/personal/.custom.hide
source $DOTFILES_SRC/personal/.seedtag.hide
# }}}


if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi



. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
