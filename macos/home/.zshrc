#!/usr/bin/env zsh

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    # time ZSH_DEBUGRC=1 zsh -i -c exit
    zmodload zsh/zprof
fi

export ZSH_THEME="robbyrussell"

source $HOME/.common.sh
source $DOTFILES_ROOT/personal/.seedtag.hide

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi


