# dotfiles

Here are my configuration files.

- `ubuntu.yaml`: Is the file where it's defined the symlinks and some
    commands.
- `bin`: Contains executables binaries or scripts.
- `git`: Git configuration.
- `shell`: Contains configuration relatives to shell like `bashrc` and `zshrc`.
- `software`: Contains scripts to install commons applications under demand.
- `vim`: Vim configuration which is a link to `config/nvim/init.lua`.
- `wm/i3`:  window manager i3 configuration.

## Installation

```bash
git clone --recurse-submodules ssh://git@gitlab.com/mmngreco/dotfiles ~/github/mmngreco/dotfiles
cd ~/.dotfiles
./install -c ubuntu.yml
```

### dotfiles-cli

```bash
dotfiles help
```

#### edit

```bash
dotfiles e   # edit
dotfiles cm  # commit
dotfiles ec  # edit and commit
```

#### install

it's possible execute every script in `software` folder from everywhere using
the bash function `dotfiles i`:

```bash
dotfiles i  # allows you to choose what to install
dotfiles i ag fzf
```

#### new


```
dotfiles new i  # new script in the software folder
dotfiles new b  # new script in the bin folder
```

## Issues

- firefox screen tearing: https://www.reddit.com/r/i4wm/comments/bk8cmw/strange_graphics_issue_when_using_i3/
