# dotfiles

Managed by `stow`.

```bash
brew install stow
# or
sudo apt install stow
```

## Installation

```bash
git clone --recurse-submodules git@github.com:asdf8601/dotfiles.git ~/.dotfiles
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

Set up by hand, outside stow: [`docs/free-my-tv.md`](docs/free-my-tv.md) —
the Samsung TV's home screen app, and `free-my-tv update` to keep it current.

Same for the Fire TV: [`docs/dumbtv-fire-tv.md`](docs/dumbtv-fire-tv.md) — the
ads and tracking are off and dumbtv home owns the HOME button; `dumbtv status`,
`dumbtv pass`, `dumbtv restore`.
