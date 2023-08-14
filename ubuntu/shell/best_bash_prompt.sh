#!/usr/bin/env bash
#
# Bash History Replacement Script
#    Author: Caesar Kabalan
#    Last Modified: June 6th, 2017
# Description:
#    Modifies the default Bash Shell prompt to be in the format of:
#       [CWD:COUNT:BRANCH:VENV]
#       [USER:HOSTNAME] _
#    Where:
#       CWD - Current working directory (green if last command returned 0, red otherwise)
#       COUNT - Session command count
#       BRANCH - Current git branch if in a git repository, omitted if not in a git repo
#       VENV - Current Python Virtual Environment if set, omitted if not set
#       USER - Current username
#       HOSTNAME - System hostname
#    Example:
#       [~/projects/losteyelid:8:master:losteyelid]
#       [ckabalan:spectralcoding] _
# Installation:
#    Add the following to one of the following files
#       System-wide Prompt Change:
#          /etc/profile.d/bash_prompt_custom.sh (new file)
#          /etc/bashrc
#       Single User Prompt Change:
#          ~/.bashrc
#          ~/.bash_profile

function set_bash_prompt () {
	# Color codes for easy prompt building
	COLOR_DIVIDER="\[\e[30;1m\]"
	COLOR_CMDCOUNT="\[\e[34;1m\]"
	COLOR_USERNAME="\[\e[34;1m\]"
	COLOR_USERHOSTAT="\[\e[34;1m\]"
	COLOR_HOSTNAME="\[\e[34;1m\]"
	COLOR_GITBRANCH="\[\e[33;1m\]"
	COLOR_VENV="\[\e[33;1m\]"
	COLOR_GREEN="\[\e[32;1m\]"
	COLOR_PATH_OK="\[\e[32;1m\]"
	COLOR_PATH_ERR="\[\e[31;1m\]"
	COLOR_NONE="\[\e[0m\]"
	# Change the path color based on return value.
	if test $? -eq 0 ; then
		PATH_COLOR=${COLOR_PATH_OK}
	else
		PATH_COLOR=${COLOR_PATH_ERR}
	fi
	# Set the PS1 to be "[workingdirectory:commandcount"
	PS1="${COLOR_DIVIDER}[${PATH_COLOR}\w${COLOR_DIVIDER}:${COLOR_CMDCOUNT}\#${COLOR_DIVIDER}"
	# Add git branch portion of the prompt, this adds ":branchname"
	if ! git_loc="$(type -p "$git_command_name")" || [ -z "$git_loc" ]; then
		# Git is installed
		if [ -d .git ] || git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
			# Inside of a git repository
			GIT_BRANCH=$(git symbolic-ref --short HEAD)
			PS1="${PS1}:${COLOR_GITBRANCH}${GIT_BRANCH}${COLOR_DIVIDER}"
		fi
	fi
	# Add Python VirtualEnv portion of the prompt, this adds ":venvname"
	if ! test -z "$VIRTUAL_ENV" ; then
		PS1="${PS1}:${COLOR_VENV}`basename \"$VIRTUAL_ENV\"`${COLOR_DIVIDER}"
	fi

	if ! test -z "$CONDA_PROMPT_MODIFIER" ; then
        conda_prompt=`echo $CONDA_PROMPT_MODIFIER | tr -d "(" | tr -d ")"`
        conda_prompt=$(basename $conda_prompt)
        PS1="${PS1}:${COLOR_VENV}$conda_prompt${COLOR_DIVIDER}"
	fi
	# Close out the prompt, this adds "]\n[username@hostname] "
	PS1="${PS1}]\n${COLOR_DIVIDER}[${COLOR_USERNAME}\u${COLOR_USERHOSTAT}@${COLOR_HOSTNAME}\h${COLOR_DIVIDER}]${COLOR_NONE} "
}

# Tell Bash to run the above function for every prompt
export PROMPT_COMMAND=set_bash_prompt
