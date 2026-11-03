# dumbtv on the Fire TV

[dumbtv](https://dumbtv.org) takes the ads, the tracking and the clutter out of a
Fire TV. Unlike Free My TV it does not ship a home screen as an app: it
**disables Amazon's promo/telemetry packages** (they stay installed), runs a DNS
filter on the TV, and replaces the HOME button with its own launcher.

Installed here: **dumbtv 1.6** on a **Fire TV Stick 4K** (`mantis`, model
`AFTMM`) running **Fire OS 6.7.1.1** (`NS6711`, Android 7.1.2, sdk 25, security
patch 2025-11-01), at `192.168.31.108`. Anything else on this network that talks
adb to it goes through a relay: see [the macOS gotcha](#things-that-waste-an-afternoon).

## Why not Free My TV

[`docs/free-my-tv.md`](free-my-tv.md) is the Samsung TV, and it works there. On
this stick the signed APK cannot install at all:

```
INSTALL_FAILED_OLDER_SDK: Requires newer sdk version #26 (current version is #25)
```

Free My TV needs Android 8; the AFTMM is stuck on Fire OS 6 and Amazon will
never move it (6.7.1.x is the last branch for the model). Patching upstream's
`--min-sdk-version` down to 25 was the plan B and was dropped: it needs a fork
of the app plus guards for `AdaptiveIconDrawable`, `NotificationChannel` and
`startForegroundService`, and would still only ever be "an app you open", never
the home screen. dumbtv ships `data/fireos6/` lists verified package by package
on **this exact model and build**, and on 6.7 it takes HOME through its own
`Keeper` service instead of an accessibility service, which 6.7 refuses.

## Commands

`~/.local/bin/dumbtv` (this repo, `macos/home/.local/bin/`) keeps the adb relay
alive, connects, and runs the upstream script you ask for:

| Command | What it does |
| --- | --- |
| `dumbtv status` | Read-only `preflight.sh`: device, platform, what a pass would change |
| `dumbtv pass` | The whole pass (`all.sh`): asks first, reboots twice, ~5 min |
| `dumbtv pass -y` | Same, reusing the saved answers in `dumbtv.conf` |
| `dumbtv verify` | `verify.sh`: the checks that end with `all checks passed` |
| `dumbtv conf -y --prime 1 --alexa 0` | Rewrite `dumbtv.conf` (the household answers) |
| `dumbtv debloat --dry-run` | Any upstream script by name: `debloat`, `lockdown`, `dnsfilter`, `launcher`, `youtube`, `home`, `discover` |
| `dumbtv restore` | `restore.sh`: re-enable everything, uninstall the launcher |
| `dumbtv shell` | `adb shell` on the TV through the relay |
| `dumbtv find` | Scan the LAN for port 5555 and print the TVs that answer |
| `dumbtv relay` | Only fix the relay and `adb connect` |

Overrides: `DUMBTV_TV_IP` (default `192.168.31.108`), `DUMBTV_SRC` (default
`~/github.com/humblemuzzu/dumbtv`), `DUMBTV_RELAY_PORT` (default `5556`).

## What a pass changed here

Answers kept in `dumbtv.conf` of the clone: `prime=1 alexa=0 launcher=1
dnsfilter=1 youtube=1`, nothing removed, nothing extra kept.

- **44 packages disabled** (not uninstalled): shopping rows, `sneakpeek`
  autoplay promos, `systemnotices`, the ad ID, `hedwig` watch tracking,
  telemetry/loggers, the OTA updaters (`forcedotaupdater.v2`, `easyupgrade`) and
  the tutorials, plus `com.mediatek.atci.service` and `com.android.carrierconfig`.
- **13 privacy settings**, and background data/work denied to 9 protected
  packages that cannot be disabled.
- **DNS filter** (`personalDNSfilter`, 399 entries, registered as an always-on
  VPN) blocking telemetry, `api.amazonalexa.com` and the update servers.
- **dumbtv home 1.6** holds HOME through `Keeper` (UsageStats +
  `moveTaskToFront`; ~0.3 s of black).
- **SmartTube 32.56** installed, Amazon's YouTube disabled but still installed.
  Alexa and the remote's mic are off; Prime Video was kept.

## Repeating it, or doing it on another Fire TV

1. On the TV: **Settings → My Fire TV → About**, press OK on the device name 7
   times, back to **My Fire TV → Developer Options → ADB debugging: on**.
2. **Settings → My TV → About → Network** for the IP, or `dumbtv find`.
3. `git clone https://github.com/humblemuzzu/dumbtv ~/github.com/humblemuzzu/dumbtv`
   (`dumbtv` expects it there).
4. `dumbtv conf -y --prime 1 --alexa 0 --launcher 1 --dnsfilter 1 --youtube 0`,
   answering the four questions as you like them.
5. `dumbtv pass`, then `dumbtv verify`.

On the TV, the first `adb` connection shows **Allow USB debugging?** — tick
*Always allow from this computer* and press OK. Nothing in the repo starts until
that is accepted.

Afterwards two things still need the remote, inside SmartTube: *Settings →
General → Hide content → Hide shorts everywhere*, and *Settings → Player → Video
presets → 1080p 60fps vp9* (not av01: this stick has no hardware decoder for it).

## Things that waste an afternoon

- **Homebrew's `adb` cannot reach the LAN on macOS.** Local network privacy
  returns `EHOSTUNREACH` for every non-Apple binary, so `adb connect
  192.168.31.108:5555` fails with *No route to host* while `/usr/bin/nc` reaches
  the same port and `dumbtv.org`'s own reports suggest the TV is at fault. It is
  not the TV. `dumbtv` starts a TCP relay with `/usr/bin/python3` from
  `127.0.0.1:5556` to the TV and hands that serial to upstream as `ADB_SERIAL`,
  which every dumbtv script honours. The permanent fix is the *Local Network*
  permission in System Settings → Privacy & Security, or an adb macOS trusts.
- **A sleeping Fire TV leaves the network.** Not "answers ping slowly": ARP
  fails and the TV is simply gone (`Host is down`), while the Developer Options
  switch still shows ADB debugging ON, so the switch is not evidence. Press a
  button on the remote before running anything. `dumbtv` checks port 5555 before
  touching adb and says this instead of hanging on an `offline` transport.
- **The IP moves.** DHCP gave `.105` and then `.108` while this was set up, so the
  relay remembers the target it started with and `dumbtv` restarts it when the
  address changes — a stale relay looks exactly like a dead TV. `dumbtv find`
  scans the LAN for port 5555; mDNS also names the TV
  (`dns-sd -B _amzn-wplay._tcp local` shows `amzn.dmgr:…` with the model and
  MAC).
- **Port 5555 refuses after a reboot** on some builds even with ADB debugging
  still showing ON: toggle it off and on in Developer Options. Worth doing before
  blaming the relay.
- **`adb install` of SmartTube reports failure and then works.** The streaming
  installer failed once and the script's retry installed it; trust
  `dumbtv verify` (`versionName=32.56`), not that line of the log.
- **No more Fire OS updates.** The DNS filter blocks the update servers, and
  that is the point. This TV is on its last branch anyway, but restoring updates
  means `dumbtv restore`.
- **Alexa off is not reversible from the app.** `alexa=0` disables Alexa and the
  microphone app; the remote's voice button then does nothing. `dumbtv conf
  --alexa 1` plus another `dumbtv pass` brings it back.
- **Nothing is uninstalled, so nothing is lost.** Your 14 third-party apps were
  untouched; the disabled packages still sit on the TV and `pm enable` brings
  any of them back one by one.
- **Launcher ordering is on the TV**, in *Options* inside dumbtv home (written to
  `home.conf` on the device), not in the clone.

## Reverting

```bash
dumbtv restore
```

That re-enables the disabled packages, unregisters the filter, uninstalls
`tv.dumbtv.home` and gives HOME back to Amazon's launcher. One package at a time
is also fine: `adb -s 127.0.0.1:5556 shell pm enable <package>`. A factory reset
undoes everything including the filter's VPN entry. Afterwards stop the relay
with `lsof -ti tcp:5556 -sTCP:LISTEN | xargs kill` if you are done with adb on
this TV (the relay lives in `~/.cache/dumbtv/`, not in this repo, because it is
plumbing for a macOS permission bug rather than something the TV needs).

## Reading upstream

`scripts/all.sh` is the order (`preflight → configure → debloat → lockdown →
dnsfilter → launcher → youtube → verify`); `data/fireos6/` is the Fire OS 6
package set with `never-disable.txt` as the hard floor; `launcher/` is the APK
source, built against `platforms;android-25` so one binary runs on Fire OS 6, 7
and 8, with `Keeper.java` doing the 6.7 HOME takeover; `docs/HOW-IT-WORKS.md`
explains why the DNS filter is a VPN and what still resolves through the router.
