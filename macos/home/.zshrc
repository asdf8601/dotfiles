#!/usr/bin/env zsh

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    # time ZSH_DEBUGRC=1 zsh -i -c exit
    zmodload zsh/zprof
fi

export PATH="$HOME/go/bin:/home/mgreco/.go/bin:/usr/local/go/bin:/opt/mssql-tools/bin:$GEM_HOME/bin:$PATH:/usr/local/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin"
export MYGITPROJECTS="$HOME/github.com:$HOME/gitlab.com"
source $HOME/.common.sh
# export PS1="%F{magenta}%n%f@%F{green}%M%f:%F{cyan}%~%f %F{magenta}(%T)%f %F{green}\$%f "
# export PS1="%F{magenta}%n%f@%F{green}%m%f:%F{cyan}%1d%f %F{magenta}(%D{%L:%M:%S})%f %F{green}\$%f "
export PS1="%F{cyan}%1d%f %F{magenta}(%D{%X})%f %F{green}\$%f "

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi


