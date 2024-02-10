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
stow ~/.dotfiles/ubuntu/home/ -t ~/
```

## macOS

```bash
stow ~/.dotfiles/macos/home/ -t ~/
```
