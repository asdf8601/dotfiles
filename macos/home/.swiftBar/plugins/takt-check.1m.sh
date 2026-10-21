#!/usr/bin/env bash

# <xbar.title>Takt: time manager</xbar.title>
# <xbar.version>v0.1</xbar.version>
# <xbar.author>Max Greco</xbar.author>
# <xbar.author.github>mmngreco</xbar.author.github>
# <xbar.desc>Takt</xbar.desc>
# <xbar.dependencies>bash</xbar.dependencies>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.environment>[EDITOR=nvim, TAKT_FILE=/Users/mgreco/.takt-log/seedtag.csv, ... ]</swiftbar.environment>

takt=/Users/mgreco/.local/bin/takt

# Clicking the title toggles in/out, then refreshes takt.5m.sh too so its hours
# are not stale until the next run.
if [[ $1 == toggle ]]; then
  /Users/mgreco/.local/bin/takt-cmp
  open -g "swiftbar://refreshallplugins"
  exit 0
fi

# Warn about a forgotten check out after this many minutes in, or past this hour.
max_in_min=660
late_hour=18

read -r ts status < <($takt cat 1 | tail -1)
hhmm=${ts:11:5}
self="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

# An empty log leaves only the header line, so status is "kind" there.
case $status in
  in)
    in_min=$((($(date +%s) - $(date -j -f %Y-%m-%dT%H:%M:%S "${ts:0:19}" +%s)) / 60))
    if ((in_min > max_in_min || 10#$(date +%H) >= late_hour)); then
      icon="⚠️"
      tip="entrada $hhmm · $((in_min / 60))h$(printf %02d $((in_min % 60))) dentro"
    else
      icon="👨‍💻"
      tip="entrada $hhmm"
    fi
    ;;
  out)
    icon="☕️"
    tip="salida $hhmm"
    ;;
  *)
    icon="❓"
    tip="sin registros"
    ;;
esac
echo "$icon | bash=$self param1=toggle terminal=false tooltip=\"$tip\""
