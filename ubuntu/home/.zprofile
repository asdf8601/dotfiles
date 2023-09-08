#!/usr/bin/env zsh
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
[ -d "$HOME/.cargo/" ] && . "$HOME/.cargo/env"

# opam configuration
test -r /home/mgreco/.opam/opam-init/init.sh && . /home/mgreco/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
