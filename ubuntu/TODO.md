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

2. [ ] Copy the secrets item from the Mac **before** pulling `personal`,
   otherwise the shell starts without tokens. From the Mac:

   ```bash
   security find-generic-password -s dotfiles -a env -w \
     | ssh <ubuntu-host> 'secret-tool store --label="dotfiles shell secrets" service dotfiles account env'
   ```

   `secret-tool` needs an unlocked desktop keyring. If it fails over SSH with
   a D-Bus error, run `secret-tool store --label="dotfiles shell secrets"
   service dotfiles account env` in a terminal on the Ubuntu desktop and paste
   the output of the Mac command.

3. [ ] Pull and install:

   ```bash
   cd ~/.dotfiles && git pull --recurse-submodules && make ubuntu
   ```

4. [ ] Open a new shell and check:

   ```bash
   echo $DOTFILES_SECRETS      # 1
   [[ -n $JIRA_API_TOKEN ]] && echo tokens-ok
   whence -w new-secret-set    # function
   ```

5. [ ] Convert any remaining `.autoenv` files to `.envrc`, then remove
   `~/.autoenv`:

   ```bash
   find ~/github.com ~/gitlab.com -maxdepth 6 -name .autoenv
   ```

6. [ ] For the team repos with `use flake` (ssp-service, buying-engine-service,
   terraform_adexchange_infra, adexchange-grafana-dashboards), install nix and
   nix-direnv:

   ```bash
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install
   nix profile add nixpkgs#nix-direnv
   ```

7. [ ] Delete this file and commit.
