#!/bin/bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.refreshOnOpen>true</swiftbar.refreshOnOpen>
# Rollouts of the services below in the 5 adserving DCs: the release from GitHub
# (latest image bump of the deployment, the merges its CI runs built, any newer
# run) and the pods from kubectl.
# Title: one line per service with news, SwiftBar cycles them. The glyphs are
# one per DC in the order euw usc usw use ase:
#   █ done  ▒ rolling  ░ waiting (DC not on the release yet)  ✗ kubectl error  · not deployed
# While idle, scheduled runs only redraw the cache; GitHub and the clusters are
# queried when the menu opens, on Refresh, or via
# swiftbar://refreshplugin?name=rollout, and the menu updates when that query ends.
# During a build or rollout, scheduled runs query the clusters, and GitHub only
# for the services still building.
# Hold Option on a merge row to copy its sha instead of opening the PR.

export PATH="/opt/homebrew/bin:$PATH"
unset GH_TOKEN GITHUB_TOKEN

if [[ $1 == copy ]]; then
  printf %s "$2" | pbcopy
  exit 0
fi

# repo, CI workflow, deployment (also its deploy/<name> dir and app label), short name
services='
seedtag/ssp-service           goci.yml                         ssp-service                    ssp
seedtag/buying-engine-service goci.yml                         buying-engine-service          be
seedtag/adx-data              reserve-price-service-cicd.yml   reserve-price-service          rp
seedtag/adx-data              header-bidding-service-cicd.yml  header-bidding-pricing-service hbp
seedtag/adx-data              ad-unit-kpi-service-cicd.yml     ad-unit-kpi-service            kpi
'
dcs="euw usc usw use ase"
cache=~/.cache/rollout
mkdir -p "$cache/dc" "$cache/gh"

svcs_json=$(awk 'NF { printf "%s{\"repo\":\"%s\",\"wf\":\"%s\",\"dep\":\"%s\",\"short\":\"%s\"}", (n++ ? "," : "["), $1, $2, $3, $4 } END { print "]" }' <<<"$services")
apps=$(jq -r 'map(.dep) | join(",")' <<<"$svcs_json")

# One summary per DC and service. The new ReplicaSet is the one with the highest
# revision; the rollout ends when kube-controller-manager scales the previous one
# to 0. Deployments that keep no old ReplicaSets (revisionHistoryLimit 0) take
# the end from their Progressing condition.
summarize='
def rev: .metadata.annotations["deployment.kubernetes.io/revision"] | tonumber;
def spec_update: [.metadata.managedFields[]?
  | select(.manager == "kube-controller-manager" and (.subresource // "") == "") | .time] | max;
.items as $items
| [$apps | split(",")[] as $app
   | ($items | map(select(.kind == "Deployment" and .metadata.name == $app)) | .[0]) as $dep
   | select($dep)
   | ($items | map(select(.kind == "ReplicaSet" and .metadata.ownerReferences[0].name == $app)) | sort_by(rev)) as $rs
   | {dc: $dc, app: $app,
      tag: ($dep.spec.template.spec.containers[0].image | split(":")[1]),
      desired: $dep.spec.replicas,
      updated: ($dep.status.updatedReplicas // 0),
      old: (($dep.status.replicas // 0) - ($dep.status.updatedReplicas // 0)),
      avail: ($rs[-1].status.availableReplicas // 0),
      start: $rs[-1].metadata.creationTimestamp,
      end: ((if ($rs | length) > 1 then $rs[-2] | spec_update else null end)
        // ($dep.status.conditions[]? | select(.type == "Progressing" and .reason == "NewReplicaSetAvailable")
            | .lastUpdateTime))}]'

# The release is the newest image bump of the deployment; build-<id> names the CI
# run that built it. Its merges are the head commits of the runs since the
# previous bump, failed and cancelled ones included, since their code ships in
# this build. A newer run that is not cancelled is the next build: still
# building, or failed. A successful run counts as building for 30 min while its
# bump lands, so a run that never bumps stops showing.
release='
def build_id: capture("build-(?<id>[0-9]+)").id | tonumber;
def merges(after; upto): $runs | map(select(.id > after and .id <= upto)
  | {sha, title, author, date, pr: ((.title | capture("\\(#(?<n>[0-9]+)\\)$").n) // null)});
($bumps | map(select(.title | test("^release: bump new image version to build-")))) as $b
| if ($b | length) == 0 then {app: $app, error: "no image bump in deploy/\($app)"} else
  ($b[0].title | build_id) as $bid
  | ($b[1].title // null | if . then build_id else 0 end) as $pbid
  | ($runs | map(select(.id == $bid)) | .[0]) as $run
  | ($runs | map(select(.id > $bid and .conclusion != "cancelled"
      and (.conclusion != "success" or $now - (.created | fromdateiso8601) < 1800))) | .[0]) as $ci
  | {app: $app, repo: $repo, tag: "build-\($bid)",
     bump: {sha: $b[0].sha, date: $b[0].date},
     run_url: $run.url,
     merges: merges($pbid; $bid),
     ci: (if $ci == null then null else
       {id: $ci.id, created: $ci.created, url: $ci.url,
        state: (if $ci.conclusion == null or $ci.conclusion == "success" then "building" else "failed" end),
        merges: merges($bid; $ci.id)} end)}
  end'

fetch_gh() {
  local repo=$1 wf=$2 dep=$3 runs bumps rel ci_id jobs out=$cache/gh/$3
  if ! runs=$(command gh api "repos/$repo/actions/workflows/$wf/runs?branch=main&per_page=20" \
    --jq '[.workflow_runs[] | {id, sha: .head_sha, conclusion, created: .created_at, url: .html_url,
           title: (.head_commit.message | split("\n")[0]), author: .actor.login, date: .head_commit.timestamp}]' 2>&1) ||
    ! bumps=$(command gh api "repos/$repo/commits?sha=main&path=deploy/$dep/kustomization.yml&per_page=5" \
      --jq '[.[] | {sha, date: .commit.author.date, title: (.commit.message | split("\n")[0])}]' 2>&1); then
    jq -cn --arg app "$dep" --arg err "$(tail -1 <<<"$runs$bumps")" '{app: $app, error: $err}' >"$out.tmp"
  else
    rel=$(jq -cn --arg app "$dep" --arg repo "$repo" --argjson runs "$runs" --argjson bumps "$bumps" \
      --argjson now "$(date +%s)" "$release")
    ci_id=$(jq -r '.ci.id // empty' <<<"$rel")
    if [[ -n $ci_id ]]; then
      jobs=$(command gh api "repos/$repo/actions/runs/$ci_id/jobs" \
        --jq '[.jobs[] | {name, status, conclusion, url: .html_url}]' 2>/dev/null) || jobs='[]'
      rel=$(jq -c --argjson jobs "$jobs" '.ci.jobs = $jobs' <<<"$rel")
    fi
    echo "$rel" >"$out.tmp"
  fi
  mv "$out.tmp" "$out.json"
}

# Queries every DC, and GitHub for the deployments given (all when none).
fetch() {
  local only=" $* "
  while read -r repo wf dep short; do
    [[ -n $dep ]] && { [[ $# -eq 0 || $only == *" $dep "* ]]; } && fetch_gh "$repo" "$wf" "$dep" &
  done <<<"$services"
  for dc in $dcs; do
    (
      if out=$(kubectl --context "$dc" -n default get deploy,rs -l "app in ($apps)" \
        --show-managed-fields -o json 2>&1); then
        jq -c --arg dc "$dc" --arg apps "$apps" "$summarize" <<<"$out" >"$cache/dc/$dc.tmp"
      else
        jq -cn --arg dc "$dc" --arg err "$(head -1 <<<"$out")" '{dc: $dc, error: $err}' >"$cache/dc/$dc.tmp"
      fi
      mv "$cache/dc/$dc.tmp" "$cache/dc/$dc.json"
    ) &
  done
  wait
}

dc_files() { for dc in $dcs; do [[ -f $cache/dc/$dc.json ]] && echo "$cache/dc/$dc.json"; done; }

# Per service: its rows per DC with a state against the release from GitHub, or
# against the newest image in any DC if GitHub failed.
model='
def bid: split("-")[1] | tonumber;
[$svcs[] as $sv
 | ($gh | map(select(.app == $sv.dep)) | .[0]) as $g
 | [$dcs[] | if type == "object" then . else (.[] | select(.app == $sv.dep)) end] as $rows
 | ($g.tag // ([$rows[] | select(.tag) | .tag] | max_by(bid))) as $target
 | ($rows | map(. + {state:
     (if .error then "error"
      elif .tag != $target then "waiting"
      elif .old > 0 or .updated < .desired then "rolling"
      else "done" end)})) as $d
 | {sv: $sv, gh: $g, target: $target, dcs: $d,
    rolling: any($d[]; .state == "rolling" or .state == "waiting"),
    building: ($g.ci.state == "building")}]'

run_model() {
  jq -n --argjson svcs "$svcs_json" \
    --slurpfile dcs <(cat $(dc_files) 2>/dev/null) \
    --slurpfile gh <(cat "$cache"/gh/*.json 2>/dev/null) \
    "$@"
}

cache_age() {
  local f=$(dc_files | head -1)
  [[ -n $f ]] && echo $(($(date +%s) - $(stat -f %m "$f"))) || echo 999999
}

# A requested refresh draws the cache at once and queries in the background,
# then asks SwiftBar to redraw; that redraw sees a fresh cache and stops there.
case $SWIFTBAR_PLUGIN_REFRESH_REASON in
  Schedule | FirstLaunch)
    if [[ -n $(dc_files) ]] && run_model -e "$model | any(.[]; .rolling or .building)" >/dev/null; then
      # "_" keeps the list non-empty, so no building service means no GitHub calls.
      fetch $(run_model -r "$model | .[] | select(.building) | .sv.dep") _
    fi
    ;;
  *)
    if (($(cache_age) > 5)); then
      (fetch; open -g "swiftbar://refreshplugin?name=rollout") </dev/null >/dev/null 2>&1 &
    fi
    ;;
esac

if [[ -z $(dc_files) ]]; then
  echo "| sfimage=shippingbox"
  echo "---"
  echo "Refresh | refresh=true"
  exit 0
fi

checked_file=$(dc_files | head -1)
if [[ $(date -r "$checked_file" +%F) == $(date +%F) ]]; then
  checked=$(date -r "$checked_file" +%H:%M)
else
  checked=$(date -r "$checked_file" "+%d/%m %H:%M")
fi

run_model -r --arg self "$0" --arg checked "$checked" --argjson now "$(date +%s)" --arg order "$dcs" "$model"' |
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
def merge_rows($repo; prefix):
  "\(prefix)\(.sha[0:9])  \(.title | clean | .[0:70])  \(.author) \(.date | hm) | href="
    + (if .pr then "https://github.com/\($repo)/pull/\(.pr)" else "https://github.com/\($repo)/commit/\(.sha)" end)
    + " font=Menlo size=12 symbolize=false",
  "\(prefix)\(.sha[0:9])  copiar sha | alternate=true bash=\($self) param1=copy param2=\(.sha) terminal=false font=Menlo size=12";
def merges_block($repo):
  if length <= 3 then .[] | merge_rows($repo; "")
  else "\(length) merges | font=Menlo size=12", (.[] | merge_rows($repo; "--")) end;

# Adds what the title and menu need to each service.
def enrich:
  . as $s
  | ([$s.dcs[] | select(.state == "done" and .end and (.end | t) > (.start | t)) | .end | t] | max) as $last_end
  | ([$s.dcs[] | select(.state != "error" and .tag == $s.target) | .start | t] | min
     // ($s.gh.bump.date // null | if . then t else null end)) as $first_start
  | . + {last_end: $last_end, title:
      (if $s.rolling then
         "🚀 \($s.sv.short) \([$order | split(" ")[] as $dc | ($s.dcs | map(select(.dc == $dc)) | .[0] | if . then glyph else "·" end)] | join("")) \(($now - $first_start) | mins) | font=Menlo"
       elif $s.building then "🚀 \($s.sv.short) ⏳ CI \(($now - ($s.gh.ci.created | t)) | mins)"
       elif $s.gh.ci.state == "failed" then "🚀 \($s.sv.short) ✗ CI | color=red"
       elif $last_end and ($now - $last_end) < 1800 then "🚀 \($s.sv.short) ✅ \(($now - $last_end) | mins)"
       else null end)};

def section:
  . as $s | ($s.gh.ci // null) as $ci | ($s.gh.repo // $s.sv.repo) as $repo
  | (if $s.gh.tag then
       "🚀 \($s.sv.dep)  \($s.gh.tag)  bump \($s.gh.bump.sha[0:9]) · \($s.gh.bump.date | hm)"
         + (if $s.gh.run_url then " | href=\($s.gh.run_url)" else "" end),
       ($s.gh.merges | merges_block($repo))
     else "\($s.sv.dep)  \($s.target)" end),
    (if $s.gh.error then "❌ gh  \($s.gh.error | clean | .[0:60]) | color=red" else empty end),
    "---",
    ($s.dcs[] |
      if .state == "error" then "\(.dc | pad(5))\(state_text)  \(.error | clean | .[0:60])\(mono) color=red"
      elif .state == "waiting" then "\(.dc | pad(5))\(state_text | pad(11))  \(.tag)"
        + (if $s.gh.bump then "  bump hace \(($now - ($s.gh.bump.date | t)) | mins)" else "" end) + mono
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
       ($ci.merges | merges_block($repo)),
       ($ci.jobs // [] | .[] | "\(job_icon) \(.name | clean) | href=\(.url) font=Menlo size=12"
         + (if job_icon == "❌" then " color=red" else "" end))
     else empty end);

def summary:
  "\(.sv.dep | pad(31))\(.target // "?" | pad(18))"
  + (if any(.dcs[]; .state == "error") or .gh.error then "❌"
     elif .last_end then "✅ \(.last_end | strflocaltime("%d/%m %H:%M"))" else "" end)
  + mono;

map(enrich) as $all
| ($all | map(select(.title or .gh.error or any(.dcs[]; .state == "error")))) as $news
| ($all - $news) as $quiet
| ([$all[] | .title | select(.)]) as $titles
| (if any($all[].dcs[]; .error and (.error | test("credential|token|auth|login"; "i"))) then "🚀 🔑 | color=red"
   elif ($titles | length) > 0 then $titles[]
   else "| sfimage=shippingbox" end),
  ($news[] | "---", section),
  (if ($quiet | length) > 0 then "---", ($quiet[] | summary, (section | "--" + .)) else empty end),
  "---",
  "consultado \($checked) | color=gray",
  "Refresh | refresh=true"
'
