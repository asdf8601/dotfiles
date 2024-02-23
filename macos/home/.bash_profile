#!/usr/bin/env bash
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
[ -d "$HOME/.cargo/" ] && . "$HOME/.cargo/env"

# opam configuration
test -r $HOME/.opam/opam-init/init.sh && . $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# if [[ "do-etls" = "$(hostname)" ]]; then
#     export TERM=xterm-256color
#     [ -f $HOME/.profile ] && source $HOME/.profile
# fi


# >>> coursier install directory >>>
export PATH="$PATH:/Users/mgreco/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/mgreco/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/mgreco/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/mgreco/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/mgreco/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

