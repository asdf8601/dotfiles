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

### Keyboard types `~` as `±`

macOS saved the keyboard as ISO instead of ANSI. This usually happens when the
setup assistant runs for a new keyboard and the key gets pressed on the wrong one.
Set the keyboard back to ANSI (`40`; `41` is ISO). The key is
`<idProduct>-<idVendor>-0`, and the Dactyl-Manuform's is `13622-17485-0`:

```bash
defaults read /Library/Preferences/com.apple.keyboardtype
osascript -e 'do shell script "defaults write /Library/Preferences/com.apple.keyboardtype keyboardtype -dict-add \"13622-17485-0\" -int 40" with administrator privileges'
```

Then unplug the keyboard and plug it back in. To find another keyboard's ids:
`ioreg -p IOUSB -l -w0 | grep -E '"USB Product Name"|"idVendor"|"idProduct"'`.
