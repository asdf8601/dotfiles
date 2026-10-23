#!/bin/bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.refreshOnOpen>true</swiftbar.refreshOnOpen>
# Rollout of ssp-service in the 5 adserving DCs: the release from GitHub (latest
# image bump on main, its merges, the CI run after it) and the pods from kubectl.
# Title: one glyph per DC in the order euw usc usw use ase:
#   █ done  ▒ rolling  ░ waiting (DC not on the release yet)  ✗ kubectl error
# While idle, scheduled runs only redraw the cache; GitHub and the clusters are
# queried when the menu opens, on Refresh, or via
# swiftbar://refreshplugin?name=rollout, and the menu updates when that query ends.
# Hold Option on a merge row to copy its sha instead of opening the PR.

export PATH="/opt/homebrew/bin:$PATH"
unset GH_TOKEN GITHUB_TOKEN

if [[ $1 == copy ]]; then
  printf %s "$2" | pbcopy
  exit 0
fi

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

# The release is the newest image bump on main. Its merges are the commits the
# CI run built since the previous run, without the bot's bump commits. A newer
# run that is not cancelled is the next build: still building, or failed.
# A successful run counts as building for 30 min while its bump lands.
release='
def build_id: capture("build-(?<id>[0-9]+)").id | tonumber;
def is_bump: .title | test("^release: bump new image version to build-");
def between(newer; older):
  ($commits | map(.sha)) as $shas
  | ($shas | index(newer)) as $i
  | (if older then $shas | index(older) else null end) as $j
  | if $i == null then [] else $commits[$i:($j // ($commits | length))] end
  | map(select(is_bump | not) | . + {pr: ((.title | capture("\\(#(?<n>[0-9]+)\\)$").n) // null)});
($commits | map(select(is_bump))) as $bumps
| if ($bumps | length) == 0 then {error: "no image bump in the last 50 commits of main"} else
  ($bumps[0].title | build_id) as $bid
  | ($bumps[1].title // null | if . then build_id else null end) as $pbid
  | ($runs | map(select(.id == $bid)) | .[0]) as $run
  | ($runs | map(select(.id == $pbid)) | .[0]) as $prun
  | ($runs | map(select(.id > $bid and .conclusion != "cancelled"
      and (.conclusion != "success" or $now - (.created | fromdateiso8601) < 1800))) | .[0]) as $ci
  | {tag: "build-\($bid)",
     bump: {sha: $bumps[0].sha, date: $bumps[0].date},
     run_url: $run.url,
     merges: between($run.sha // $bumps[0].sha; $prun.sha // $bumps[1].sha),
     ci: (if $ci == null then null else
       {id: $ci.id, created: $ci.created, url: $ci.url,
        state: (if $ci.conclusion == null or $ci.conclusion == "success" then "building" else "failed" end),
        merges: between($ci.sha; $run.sha // $bumps[0].sha)} end)}
  end'

fetch_gh() {
  local runs commits rel ci_id jobs
  if ! runs=$(command gh api "repos/seedtag/$app/actions/workflows/goci.yml/runs?branch=main&per_page=10" \
    --jq '[.workflow_runs[] | {id, sha: .head_sha, conclusion, created: .created_at, url: .html_url}]' 2>&1) ||
    ! commits=$(command gh api "repos/seedtag/$app/commits?sha=main&per_page=50" \
      --jq '[.[] | {sha, date: .commit.author.date, author: (.author.login // .commit.author.name),
               title: (.commit.message | split("\n")[0])}]' 2>&1); then
    jq -cn --arg err "$(tail -1 <<<"$runs$commits")" '{error: $err}' >"$cache/gh.tmp"
  else
    rel=$(jq -cn --argjson runs "$runs" --argjson commits "$commits" --argjson now "$(date +%s)" "$release")
    ci_id=$(jq -r '.ci.id // empty' <<<"$rel")
    if [[ -n $ci_id ]]; then
      jobs=$(command gh api "repos/seedtag/$app/actions/runs/$ci_id/jobs" \
        --jq '[.jobs[] | {name, status, conclusion, url: .html_url}]' 2>/dev/null) || jobs='[]'
      rel=$(jq -c --argjson jobs "$jobs" '.ci.jobs = $jobs' <<<"$rel")
    fi
    echo "$rel" >"$cache/gh.tmp"
  fi
  mv "$cache/gh.tmp" "$cache/gh.json"
}

fetch() {
  fetch_gh &
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

# Shared by the active check and the renderer: each DC gets a state against the
# release from GitHub, or against the newest image in any DC if GitHub failed.
states='
def bid: split("-")[1] | tonumber;
($gh.tag // ([.[] | select(.tag) | .tag] | max_by(bid))) as $target
| map(. + {state:
    (if .error then "error"
     elif .tag != $target then "waiting"
     elif .old > 0 or .updated < .desired then "rolling"
     else "done" end)})
| {target: $target, dcs: .}'

files() { for dc in $dcs; do [[ -f $cache/$dc.json ]] && echo "$cache/$dc.json"; done; }
gh_json() { cat "$cache/gh.json" 2>/dev/null || echo null; }

active() {
  [[ -n $(files) ]] && jq -se --argjson gh "$(gh_json)" \
    "$states | any(.dcs[]; .state == \"rolling\" or .state == \"waiting\") or \$gh.ci.state == \"building\"" \
    $(files) >/dev/null
}

cache_age() {
  local f=$(files | head -1)
  [[ -n $f ]] && echo $(($(date +%s) - $(stat -f %m "$f"))) || echo 999999
}

# A requested refresh draws the cache at once and queries in the background,
# then asks SwiftBar to redraw; that redraw sees a fresh cache and stops there.
case $SWIFTBAR_PLUGIN_REFRESH_REASON in
  Schedule | FirstLaunch) active && fetch ;;
  *)
    if (($(cache_age) > 5)); then
      (fetch; open -g "swiftbar://refreshplugin?name=rollout") </dev/null >/dev/null 2>&1 &
    fi
    ;;
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

jq -sr --arg app $app --arg self "$0" --arg checked "$checked" --argjson now "$(date +%s)" \
  --argjson gh "$(gh_json)" "$states"' |
def t: fromdateiso8601;
def hm: t | strflocaltime("%H:%M");
def pad(n): tostring | if length < n then . + (" " * (n - length)) else . end;
def lpad(n): tostring | if length < n then (" " * (n - length)) + . else . end;
def dur: floor | if . >= 3600 then "\(. / 3600 | floor)h\(. % 3600 / 60 | floor)m"
  else "\(. / 60 | floor)m\(. % 60 | tostring | lpad(2) | gsub(" "; "0"))s" end;
def glyph: {done: "█", rolling: "▒", waiting: "░", error: "✗"}[.state];
def state_text: {done: "✅ done", rolling: "🔄 rolling", waiting: "⏳ waiting", error: "❌ kubectl"}[.state];
def job_icon: if .status != "completed" then "🔄" elif .conclusion == "success" then "✅"
  elif .conclusion == "skipped" then "–" else "❌" end;
def mins: "\(. / 60 | floor)m";
def mono: " | font=Menlo size=12";
def clean: gsub("\\|"; "/");
def merge_rows(prefix):
  "\(prefix)\(.sha[0:9])  \(.title | clean | .[0:70])  \(.author) \(.date | hm) | href="
    + (if .pr then "https://github.com/seedtag/\($app)/pull/\(.pr)" else "https://github.com/seedtag/\($app)/commit/\(.sha)" end)
    + " font=Menlo size=12 symbolize=false",
  "\(prefix)\(.sha[0:9])  copiar sha | alternate=true bash=\($self) param1=copy param2=\(.sha) terminal=false font=Menlo size=12";
def merges_block:
  if length <= 3 then .[] | merge_rows("")
  else "\(length) merges | font=Menlo size=12", (.[] | merge_rows("--")) end;

. as $s
| ($gh.ci // null) as $ci
| ($s.dcs | map(select(.state == "rolling" or .state == "waiting")) | length > 0) as $active
| ([$s.dcs[] | select(.state == "done" and .end and (.end | t) > (.start | t)) | .end | t] | max) as $last_end
| ([$s.dcs[] | select(.state != "error" and .tag == $s.target) | .start | t] | min
   // ($gh.bump.date // null | if . then t else null end)) as $first_start
| (if any($s.dcs[]; .error and (.error | test("credential|token|auth|login"; "i"))) then "🚀 🔑 | color=red"
   elif $active then "🚀 \($s.dcs | map(glyph) | join("")) \(($now - $first_start) | mins) | font=Menlo"
   elif $ci.state == "building" then "🚀 ⏳ CI \(($now - ($ci.created | t)) | mins)"
   elif $ci.state == "failed" then "🚀 ✗ CI | color=red"
   elif $last_end and ($now - $last_end) < 1800 then "🚀 ✅ \(($now - $last_end) | mins)"
   else "| sfimage=shippingbox" end),
  "---",
  (if $gh.tag then
     "🚀 \($app)  \($gh.tag)  bump \($gh.bump.sha[0:9]) · \($gh.bump.date | hm)"
       + (if $gh.run_url then " | href=\($gh.run_url)" else "" end),
     ($gh.merges | merges_block)
   else "\($app)  \($s.target)" end),
  (if $gh.error then "❌ gh  \($gh.error | clean | .[0:60]) | color=red" else empty end),
  "---",
  ($s.dcs[] |
    if .state == "error" then "\(.dc | pad(5))\(state_text)  \(.error | clean | .[0:60])\(mono) color=red"
    elif .state == "waiting" then "\(.dc | pad(5))\(state_text | pad(11))  \(.tag)"
      + (if $gh.bump then "  bump hace \(($now - ($gh.bump.date | t)) | mins)" else "" end) + mono
    else
      "\(.dc | pad(5))\(state_text | pad(11))\("\(.avail)/\(.desired)" | lpad(9))\("\(if .desired > 0 then (.avail * 100 / .desired | floor) else 100 end)%" | lpad(6))  "
      + (if .state == "done" and .end and (.end | t) > (.start | t)
         then "\((.end | t) - (.start | t) | dur) → \(.end | hm)"
         else "\(($now - (.start | t)) | dur)" end)
      + mono + " tooltip=\"old \(.old) · start \(.start | hm)\""
    end),
  (if $ci then
     "---",
     (if $ci.state == "building"
      then "⏳ build en curso \(($now - ($ci.created | t)) | mins) | href=\($ci.url)"
      else "✗ CI failed, nothing will roll out | href=\($ci.url) color=red" end),
     ($ci.merges | merges_block),
     ($ci.jobs // [] | .[] | "\(job_icon) \(.name | clean) | href=\(.url) font=Menlo size=12"
       + (if job_icon == "❌" then " color=red" else "" end))
   else empty end),
  "---",
  "consultado \($checked) | color=gray",
  "Refresh | refresh=true"
' $(files)
