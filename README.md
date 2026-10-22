# dotfiles

Managed by `stow`.

```bash
brew install stow
# or
sudo apt install stow
```

## Installation

```bash
git clone --recurse-submodules ssh://git@gitlab.com/mmngreco/dotfiles ~/.dotfiles
```


## Ubuntu

```bash
make ubuntu
```

> **Pending:** the 2026-10-22 changes (direnv, libsecret secrets) were never run
> on Ubuntu. Follow [`ubuntu/TODO.md`](ubuntu/TODO.md) before `make ubuntu`.

## macOS

```bash
make macos
```
