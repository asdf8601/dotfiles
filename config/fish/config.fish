
# Generated automatically at 2018-05-05T12:17:1525515448

# ALIASES
# =======

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
alias edit='nano'

# Git
alias gcl='git clone '
alias gst='git status'
alias gb='git branch'
alias go='git checkout'
alias gob='git checkout -b '
alias ga='git add '
alias gc='git commit'
alias gl='git pull '
alias gh='git push '
alias glom='git pull origin master'
alias ghom='git push origin master'
alias gg='git grep '

# Output
alias lcase="tr '[:upper:]' '[:lower:]'"
alias ucase="tr '[:lower:]' '[:upper:]'"

# System
alias df="df -h"
alias du="du -h"
# CORES='nproc'
# JOBS=$(expr $CORES + 1)
# alias make="make -j$JOBS"

# Files
alias lcf="rename 'y/A-Z/a-z/' "
alias ucf="rename 'y/a-z/A-Z/' "

# Vim
alias v='vim'
alias nv='nvim'

# Tmux
alias tn='tmux set -g mode-mouse on'
alias tf='tmux set -g mode-mouse off'
alias tmux='tmux -2'

# Grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# Wget
alias wgetncc='wget --no-check-certificate'

# Utils
alias sitecopy='wget -k -K -E -r -l 10 -p -N -F -nH '
alias ytmp3='youtube-dl --extract-audio --audio-format mp3 '
alias pipclean='curl https://gist.githubusercontent.com/mmngreco/afafe8c37498f8185d25b2648c57f73a/raw/pip_clean.py > ~/pipclean.py; python ~/pipclean.py; rm ~/pipclean.py'


# docker
alias datt='docker attach'
alias dcb='docker-compose build'
alias dclogs='docker-compose logs'
alias dcu='docker-compose up'
alias ddiff='docker diff'
alias deb='dexbash'
alias dimg='docker images'
alias dins='docker inspect'
alias dps='docker ps'
alias drm='docker rm'
alias drmi='docker rmi'
alias drun='docker run'
alias dstart='docker start'
alias dstop='docker stop'
# alias dclimg='docker rmi $(docker images --filter "dangling=true" -q --no-trunc)'
# alias drestartf='docker start $(docker ps -ql) ; and docker attach $(docker ps -ql)'

# ls variants
alias la='ls -A'
alias l='ls -alFtr'
alias lsd='ls -d .*'
alias ll='ls -alF'
[ -n "$OS_LIN" ] ; and alias ls='ls --color=auto'
[ -n "$OS_MAC" ] ; and alias ls='ls -G'

# Various
alias h='history | tail'
alias hg='history | grep'
alias mvi='mv -i'
alias rmi='rm -i'
alias ak='ack-grep'

# Web
alias gist='open -a Firefox https://gist.github.com/'
alias firefox='open -a Firefox'

# conda
source /Users/mmngreco/miniconda3/etc/fish/conf.d/conda.fish
conda activate base
clear
