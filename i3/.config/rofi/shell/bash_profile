#!/usr/bin/env bash
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
[ -d "$HOME/.cargo/" ] && . "$HOME/.cargo/env"

# opam configuration
test -r $HOME/.opam/opam-init/init.sh && . $HOME/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# if [[ "do-etls" = "$(hostname)" ]]; then
#     export TERM=xterm-256color
#     [ -f $HOME/.profile ] && source $HOME/.profile
# fi
