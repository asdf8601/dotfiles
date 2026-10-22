# Ubuntu: pending setup

The macOS changes from 2026-10-22 were ported to `ubuntu/home/` but never run
on an Ubuntu machine. Do these steps on the next Ubuntu session, in order, and
delete this file when they are all done.

## What changed

- **direnv replaces autoenv.** `.zshrc` and `.bashrc` load `direnv hook`;
  `.config/direnv/direnv.toml` trusts every `.envrc` under
  `/home/mgreco/github.com/seedtag`, so worktrees need no `direnv allow`.
- **API tokens left `personal/*.hide`.** They live in one libsecret item
  (service `dotfiles`, account `env`, base64 of `NAME=value` lines). `.zshrc`
  loads it through `secret-tool`; `secrets-edit` and `new-secret-set NAME`
  update it.
- **Shell cleanups.** `typeset -U path`, newer `llm` aliases, unused exports
  and commented aliases removed.

## Steps

1. [ ] Install the tools:

   ```bash
   sudo apt install direnv libsecret-tools
   ```

2. [ ] Make KeePassXC the Secret Service provider, so `secret-tool` stores
   the item in the KeePassXC database:
   - Tools > Settings > Secret Service Integration: enable it. Turn off
     "Confirm when passwords are retrieved by clients", otherwise every new
     shell pops a dialog.
   - Database > Database Settings > Secret Service Integration: expose a group,
     e.g. `dotfiles`.
   - Stop GNOME Keyring from owning the Secret Service, or KeePassXC cannot
     register it: disable the "GNOME Keyring: Secret Service" startup entry.
   - KeePassXC must be running and unlocked when a shell starts; while it is
     locked the loader finds nothing and the shell starts without tokens.

3. [ ] Copy the secrets item from the Mac **before** pulling `personal`,
   otherwise the shell starts without tokens. From the Mac:

   ```bash
   security find-generic-password -s dotfiles -a env -w \
     | ssh <ubuntu-host> 'secret-tool store --label="dotfiles shell secrets" service dotfiles account env'
   ```

   `secret-tool` needs KeePassXC unlocked in the desktop session. If it fails over SSH with
   a D-Bus error, run `secret-tool store --label="dotfiles shell secrets"
   service dotfiles account env` in a terminal on the Ubuntu desktop and paste
   the output of the Mac command.

4. [ ] Pull and install:

   ```bash
   cd ~/.dotfiles && git pull --recurse-submodules && make ubuntu
   ```

5. [ ] Open a new shell and check:

   ```bash
   echo $DOTFILES_SECRETS      # 1
   [[ -n $JIRA_API_TOKEN ]] && echo tokens-ok
   whence -w new-secret-set    # function
   ```

6. [ ] Convert any remaining `.autoenv` files to `.envrc`, then remove
   `~/.autoenv`:

   ```bash
   find ~/github.com ~/gitlab.com -maxdepth 6 -name .autoenv
   ```

7. [ ] For the team repos with `use flake` (ssp-service, buying-engine-service,
   terraform_adexchange_infra, adexchange-grafana-dashboards), install nix and
   nix-direnv:

   ```bash
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install
   nix profile add nixpkgs#nix-direnv
   ```

8. [ ] Switch the espanso `;sum`, `;chat`, `;tra` and `;fix` matches in
   `ubuntu/home/.config/espanso/match/ai-llms.yml` to
   `personal/.local/bin/espanso_pi.sh`, as on macOS. They call
   `espanso_gpt*` commands that no longer exist. `espanso_pi.sh` needs the
   `pi` CLI and its PATH line points at Homebrew, so adapt it for Linux.

9. [ ] Delete this file and commit.
