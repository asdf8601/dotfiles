#!/bin/bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.refreshOnOpen>true</swiftbar.refreshOnOpen>
# Rollout of ssp-service in the 5 adserving DCs, from kubectl only.
# Title: one glyph per DC in the order euw usc usw use ase:
#   █ done  ▒ rolling  ░ waiting (DC still on an older image)  ✗ kubectl error
# While idle, scheduled runs only redraw the cache; the clusters are queried
# when the menu opens, on Refresh, or via swiftbar://refreshplugin?name=rollout.

export PATH="/opt/homebrew/bin:$PATH"

app=ssp-service
dcs="euw usc usw use ase"
cache=~/.cache/rollout/$app
mkdir -p "$cache"

# One summary per DC. The new ReplicaSet is the one with the highest revision;
# the rollout ends when kube-controller-manager scales the previous one to 0.
summarize='
def rev: .metadata.annotations["deployment.kubernetes.io/revision"] | tonumber;
def spec_update: [.metadata.managedFields[]?
  | select(.manager == "kube-controller-manager" and (.subresource // "") == "") | .time] | max;
(.items | map(select(.kind == "Deployment" and .metadata.name == $app)) | .[0]) as $dep
| (.items | map(select(.kind == "ReplicaSet" and .metadata.ownerReferences[0].name == $app)) | sort_by(rev)) as $rs
| {dc: $dc,
   tag: ($dep.spec.template.spec.containers[0].image | split(":")[1]),
   desired: $dep.spec.replicas,
   updated: ($dep.status.updatedReplicas // 0),
   old: (($dep.status.replicas // 0) - ($dep.status.updatedReplicas // 0)),
   avail: ($rs[-1].status.availableReplicas // 0),
   start: $rs[-1].metadata.creationTimestamp,
   end: (if ($rs | length) > 1 then $rs[-2] | spec_update else null end)}'

fetch() {
  for dc in $dcs; do
    (
      if out=$(kubectl --context "$dc" -n default get deploy,rs -l app=$app \
        --show-managed-fields -o json 2>&1); then
        jq -c --arg dc "$dc" --arg app $app "$summarize" <<<"$out" >"$cache/$dc.tmp"
      else
        jq -cn --arg dc "$dc" --arg err "$(head -1 <<<"$out")" '{dc: $dc, error: $err}' >"$cache/$dc.tmp"
      fi
      mv "$cache/$dc.tmp" "$cache/$dc.json"
    ) &
  done
  wait
}

# Shared by the active check and the renderer: each DC gets a state against
# the newest image seen in any DC.
states='
def bid: split("-")[1] | tonumber;
([.[] | select(.tag) | .tag] | max_by(bid)) as $target
| map(. + {state:
    (if .error then "error"
     elif .tag != $target then "waiting"
     elif .old > 0 or .updated < .desired then "rolling"
     else "done" end)})
| {target: $target, dcs: .}'

files() { for dc in $dcs; do [[ -f $cache/$dc.json ]] && echo "$cache/$dc.json"; done; }

active() {
  [[ -n $(files) ]] && jq -se "$states | any(.dcs[]; .state == \"rolling\" or .state == \"waiting\")" $(files) >/dev/null
}

case $SWIFTBAR_PLUGIN_REFRESH_REASON in
  Schedule | FirstLaunch) active && fetch ;;
  *) fetch ;;
esac

if [[ -z $(files) ]]; then
  echo "| sfimage=shippingbox"
  echo "---"
  echo "Refresh | refresh=true"
  exit 0
fi

checked_file=$(files | head -1)
if [[ $(date -r "$checked_file" +%F) == $(date +%F) ]]; then
  checked=$(date -r "$checked_file" +%H:%M)
else
  checked=$(date -r "$checked_file" "+%d/%m %H:%M")
fi

jq -sr --arg app $app --arg checked "$checked" --argjson now "$(date +%s)" "$states"' |
def t: fromdateiso8601;
def hm: t | strflocaltime("%H:%M");
def pad(n): tostring | if length < n then . + (" " * (n - length)) else . end;
def lpad(n): tostring | if length < n then (" " * (n - length)) + . else . end;
def dur: floor | if . >= 3600 then "\(. / 3600 | floor)h\(. % 3600 / 60 | floor)m"
  else "\(. / 60 | floor)m\(. % 60 | tostring | lpad(2) | gsub(" "; "0"))s" end;
def glyph: {done: "█", rolling: "▒", waiting: "░", error: "✗"}[.state];
def state_text: {done: "✅ done", rolling: "🔄 rolling", waiting: "⏳ waiting", error: "❌ kubectl"}[.state];
def mins: "\(. / 60 | floor)m";
def mono: " | font=Menlo size=12";

. as $s
| ($s.dcs | map(select(.state == "rolling" or .state == "waiting")) | length > 0) as $active
| ([$s.dcs[] | select(.state == "done" and .end and (.end | t) > (.start | t)) | .end | t] | max) as $last_end
| ([$s.dcs[] | select(.state != "error" and .tag == $s.target) | .start | t] | min) as $first_start
| (if any($s.dcs[]; .error and (.error | test("credential|token|auth|login"; "i"))) then "🚀 🔑 | color=red"
   elif $active then "🚀 \($s.dcs | map(glyph) | join("")) \(($now - $first_start) | mins) | font=Menlo"
   elif $last_end and ($now - $last_end) < 1800 then "🚀 ✅ \(($now - $last_end) | mins)"
   else "| sfimage=shippingbox" end),
  "---",
  "\($app)  \($s.target)",
  "---",
  ($s.dcs[] |
    if .state == "error" then "\(.dc | pad(5))\(state_text)  \(.error | gsub("\\|"; "/") | .[0:60])\(mono) color=red"
    elif .state == "waiting" then "\(.dc | pad(5))\(state_text | pad(11))  \(.tag)\(mono)"
    else
      "\(.dc | pad(5))\(state_text | pad(11))\("\(.avail)/\(.desired)" | lpad(9))\("\(if .desired > 0 then (.avail * 100 / .desired | floor) else 100 end)%" | lpad(6))  "
      + (if .state == "done" and .end and (.end | t) > (.start | t)
         then "\((.end | t) - (.start | t) | dur) → \(.end | hm)"
         else "\(($now - (.start | t)) | dur)" end)
      + mono + " tooltip=\"old \(.old) · start \(.start | hm)\""
    end),
  "---",
  "consultado \($checked) | color=gray",
  "Refresh | refresh=true"
' $(files)
