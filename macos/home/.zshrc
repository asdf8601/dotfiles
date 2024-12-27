#!/usr/bin/env zsh

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    # time ZSH_DEBUGRC=1 zsh -i -c exit
    zmodload zsh/zprof
fi

export ZSH_THEME="robbyrussell"
export PATH="$HOME/go/bin:/home/mgreco/.go/bin:/usr/local/go/bin:/opt/mssql-tools/bin:$GEM_HOME/bin:$PATH:/usr/local/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/.local/bin"
export MYGITPROJECTS="$HOME/github.com:$HOME/gitlab.com"
source $HOME/.common.sh

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi


