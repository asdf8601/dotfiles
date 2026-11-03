# Free My TV on the Samsung TV

[Free My TV](https://freemytv.io) is a home screen replacement for Google TV,
Android TV, LG and Samsung. On the Samsung set it is **just an app**: Samsung's
own home screen stays where it is, nothing is debloated and nothing is rooted.
What we use it for is the clean screen with our apps, the trending picks, the
weather and the price drawer.

Installed here: **v1.3.0**, on a **UE65TU8005KXXC** (Tizen 5.5, 2020) at
`192.168.31.130`.

## Commands

`~/.local/bin/free-my-tv` (this repo, `macos/home/.local/bin/`) drives the TV
over SDB on port 26101 and downloads the signed `.wgt` from the project's
GitHub releases:

| Command | What it does |
| --- | --- |
| `free-my-tv update` | Install the latest release over the one on the TV |
| `free-my-tv update --force` | Same, even when the tag already matches |
| `free-my-tv status` | Latest release, what's installed, whether the TV answers |
| `free-my-tv open` | Launch it on the TV |
| `free-my-tv uninstall` | Remove it, and the settings kept on the TV with it |

Overrides: `FREE_MY_TV_IP` (default `192.168.31.130`), `FREE_MY_TV_SRC`
(default `~/.cache/free-my-tv`, the throwaway clone of upstream),
`FREE_MY_TV_PYTHON` (default `/usr/bin/python3`).

## Keeping it updated

There is **no self-update on Samsung** (only the Android TV APK has it), so
`free-my-tv update` is the update mechanism. It is safe to run blind: it
installs over the existing app, and the TMDB key, the city and the shelf
survive because they live on the TV, not in the package.

Run it when you remember. The monthly `dotfiles-maintenance` job does not touch
the TV: it runs unattended from launchd, and this needs the TV awake.

Versions to watch for: upstream tags releases `v1.3.0`, `v1.4.0`, ... and the
script keeps the last tag it installed in `~/.cache/free-my-tv/INSTALLED` to
know whether an update is pending.

## First install, or after a factory reset

1. On the TV: **Apps** → type `1 2 3 4 5` on the remote → **Developer mode** on
   → **Host PC IP** = this Mac's IP → restart the TV (power cycle, not standby).
2. `free-my-tv status` should now report the model and the Tizen version. If it
   doesn't, it prints what to fix.
3. `free-my-tv update`.

The TV only accepts a package signed with a certificate it already trusts.
Upstream ships the release signed with a Tizen certificate, which 2015–2022
sets take as-is; 2023+ sets need the package re-signed with a Samsung
certificate tied to the TV's DUID, which this script does not do.

## Things that waste an afternoon

- **`python3` from Homebrew cannot talk to the TV.** macOS local network
  privacy blocks it: `connect()` fails with `No route to host` while `nc` to the
  same port succeeds. Use `/usr/bin/python3`, which is what the script does.
- **A sleeping TV is not on the network.** Port 26101 disappears in standby, so
  turn the TV on and wait a few seconds before running anything.
- **`Host PC IP` must be this Mac's current IP.** DHCP changing it breaks
  installs and updates (the running app is unaffected). Reserve the lease or set
  the field again in the TV's developer menu.
- **`Autorun Last App` does not work on 2020 sets** (upstream issue #356): the
  TV won't reopen a developer-mode app on boot. Keep Free My TV in the first
  slot of the Home bar.
- **The TMDB key is only on the TV.** Typing 32 characters with the remote is
  the worst part of the whole setup; a USB keyboard plugged into the TV types
  into the field directly. The key is a personal read-only TMDB key and does not
  belong in this repo — the gitleaks pre-commit hook would flag it.
- **Uninstalling loses the settings**, including the key: they are the app's
  localStorage on the TV.

## Reverting

`free-my-tv uninstall`, or on the TV: *Apps* → *Settings* → *Free My TV* →
*Delete*. Samsung's home screen was never touched, so there is nothing else to
restore.

## Reading upstream

The parts worth knowing: `tizen/install.py` (the SDB client, no Tizen Studio
needed), `tizen/build.py` (packs and signs a custom build, needs Samsung's
`tizen` CLI), `web/` (the app itself, ES5 for old TV browsers) and `CLAUDE.md`
(upstream's notes on what fails, model by model).
