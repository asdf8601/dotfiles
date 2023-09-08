#!/usr/bin/env zsh
# -----------------------------------------------------------------------------
# PROMPT
# amuse modified

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

function preexec() {
    typeset -gi CALCTIME=1
    typeset -gi CMDSTARTTIME=SECONDS
}

function precmd() {
    if (( CALCTIME )) ; then
        typeset -gi ETIME=SECONDS-CMDSTARTTIME
    fi
    typeset -gi CALCTIME=0
}

if [ -z ${IS_DOCKER+x} ]; then
    # unset variable
    DOCKER_PROMT=""
else
    DOCKER_PROMT="[docker]"
fi


function setPrompt() {
    input=${1:-$DEFAULT_PROMPT}
    case $input in

        0|starship)
            eval "$(starship init zsh)"
            ;;

        1)
            PROMPT=''
            PROMPT+='%{$fg[blue]%}${USER}%{$reset_color%}@%{$fg[green]%}${${(%):-%M}%.local}%{$reset_color%} '
            PROMPT+='%(?:%{$fg[green]%}$:%{$fg[red]%}$)%{$reset_color%} '
            ;;

        2)
            PROMPT=''
            PROMPT+='%{$fg[blue]%}${USER}%{$reset_color%}@%{$fg[green]%}${${(%):-%M}%.local}%{$reset_color%} '
            PROMPT+='${DOCKER_PROMT}%{$fg[cyan]%}%c%{$reset_color%} '
            PROMPT+='%{$fg[red]%}$(git_prompt_info)%{$reset_color%} '
            PROMPT+='%{$fg[magenta]%}(%T|${ETIME:-0}s)%{$reset_color%} '
            PROMPT+=$'\n'
            PROMPT+='%(?:%{$fg[green]%}$:%{$fg[red]%}$)%{$reset_color%} '
            ;;

        3)
            PROMPT=''
            PROMPT+='%{$fg[blue]%}${USER}%{$reset_color%}@%{$fg[green]%}${${(%):-%M}%.local}%{$reset_color%} '
            PROMPT+='${DOCKER_PROMT}%{$fg[cyan]%}%c%{$reset_color%} '
            PROMPT+='%{$fg[red]%}$(git_prompt_info)%{$reset_color%} '
            PROMPT+='%{$fg[magenta]%}(%T|${ETIME:-0}s)%{$reset_color%} '
            PROMPT+='%(?:%{$fg[green]%}$:%{$fg[red]%}$)%{$reset_color%} '
            ;;

        4)
            PROMPT=''
            PROMPT+='%{$fg[blue]%}${USER}%{$reset_color%}@%{$fg[green]%}${${(%):-%M}%.local}%{$reset_color%} '
            PROMPT+='${DOCKER_PROMT}%{$fg[cyan]%}%c%{$reset_color%} '
            PROMPT+='%{$fg[magenta]%}(%T|${ETIME:-0}s)%{$reset_color%} '
            PROMPT+=$'\n'
            PROMPT+='%(?:%{$fg[green]%}$:%{$fg[red]%}$)%{$reset_color%} '
            ;;

        help)
            echo "Usage:"
            echo "setPrompt [1,2,3]"
            echo ""

            echo "Examples"
            echo ""
            echo "setPrompt 1 ->"
            echo "$"
            echo ""
            echo "setPrompt 2 ->"
            echo "dotfiles master* (21:42|0s)"
            echo "$"
            echo ""
            echo "setPrompt 3 ->"
            echo "dotfiles master* (21:42|0s) $"
            echo ""
            echo "setPrompt 4 ->"
            echo "dotfiles (21:42|0s) $"

            ;;

        *)
            setPrompt ${DEFAULT_PROMPT:-4}
            ;;

        esac
    }

setPrompt $DEFAULT_PROMPT
