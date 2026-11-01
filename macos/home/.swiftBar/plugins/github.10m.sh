#!/bin/bash
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# GitHub PR summary; only sections with PRs are shown:
#   🔧 my PRs blocked on me (conflicts, CI failing, changes requested, nobody asked to review)
#   🚀 my or assigned PRs ready to merge (merge state CLEAN or HAS_HOOKS)
#   ✅ PRs merged today (local day) that I authored or reviewed
#   👀 PRs where I am requested as reviewer by name (team requests excluded)
#   ⏳ my PRs waiting on a pending reviewer
#   💬 open review threads whose last human comment is not mine (on my PRs, or
#      threads I took part in on others' PRs), plus newer comments on my PRs
#   💤 PRs snoozed or hidden from the sections above; wake them from the submenu
# Each PR row has a submenu: snooze 30m/1h/2h/1d/2d, or hide. Merged rows only hide.
# Hidden state lives in ~/.local/state/swiftbar-github/hidden.tsv.

export PATH="/opt/homebrew/bin:$PATH"
unset GH_TOKEN GITHUB_TOKEN

self="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
state_dir="$HOME/.local/state/swiftbar-github"
hidden_file="$state_dir/hidden.tsv"
mkdir -p "$state_dir"

# One line per PR: url<TAB>expires_epoch. A new action replaces the old line.
hide_pr() { # url expires
  local tmp="$hidden_file.tmp"
  { [[ -f $hidden_file ]] && awk -F'\t' -v u="$1" '$1 != u' "$hidden_file"
    printf '%s\t%s\n' "$1" "$2"; } >"$tmp" && mv "$tmp" "$hidden_file"
}

case $1 in
  snooze)
    now=$(date +%s)
    case $3 in
      30m) expires=$((now + 1800)) ;;
      1h) expires=$((now + 3600)) ;;
      2h) expires=$((now + 7200)) ;;
      1d) expires=$((now + 86400)) ;;
      2d) expires=$((now + 172800)) ;;
      hide) expires=4102444800 ;;
    esac
    hide_pr "$2" "$expires"
    open -g "swiftbar://refreshplugin?name=github.10m.sh"
    exit 0
    ;;
  wake)
    tmp="$hidden_file.tmp"
    awk -F'\t' -v u="$2" '$1 != u' "$hidden_file" >"$tmp" && mv "$tmp" "$hidden_file"
    open -g "swiftbar://refreshplugin?name=github.10m.sh"
    exit 0
    ;;
esac

pr_fragment='
fragment pr on PullRequest {
  number title url isDraft createdAt mergeStateStatus reviewDecision additions deletions
  repository { name nameWithOwner owner { login } }
  author { login }
  reviewRequests(first: 10) {
    nodes { requestedReviewer { ... on User { login } ... on Team { slug } } }
  }
  timelineItems(itemTypes: [REVIEW_REQUESTED_EVENT], last: 20) {
    nodes { ... on ReviewRequestedEvent { createdAt requestedReviewer { ... on User { login } ... on Team { slug } } } }
  }
  commits(last: 1) { nodes { commit { statusCheckRollup { state } } } }
}'
discussion_fragment='
fragment discussion on PullRequest {
  number title url createdAt
  repository { name nameWithOwner owner { login } }
  author { login }
  commits(last: 1) { nodes { commit { committedDate } } }
  reviewThreads(first: 50) {
    nodes { isResolved isOutdated comments(first: 20) { nodes { author { __typename login } createdAt } } }
  }
  comments(last: 20) { nodes { author { __typename login } createdAt } }
}'
merged_fragment='
fragment merged on PullRequest {
  number title url mergedAt
  repository { name nameWithOwner owner { login } }
  author { login }
}'

# One big query runs past GitHub's ~10s GraphQL timeout (502/504), so each
# search is its own request, run in parallel and retried once.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
# GitHub filters merged dates in UTC, so ask from yesterday and filter by local day later.
yesterday=$(date -v-1d +%F)
today=$(date +%F)

search() { # name fragment spread search first
  local fragment=$pr_fragment
  [[ $2 == discussion ]] && fragment=$discussion_fragment
  [[ $2 == merged ]] && fragment=$merged_fragment
  local query="$fragment
query { viewer { login } $1: search(query: \"$3\", type: ISSUE, first: $4) { nodes { ...$2 } } }"
  gh api graphql -f query="$query" >"$tmp/$1" 2>&1 ||
    gh api graphql -f query="$query" >"$tmp/$1" 2>&1 ||
    { mv "$tmp/$1" "$tmp/$1.failed"; echo "{\"data\": {\"$1\": {\"nodes\": []}}}" >"$tmp/$1"; }
}

search authored pr "is:open is:pr archived:false author:@me" 100 &
search authoredDiscussion discussion "is:open is:pr archived:false author:@me" 100 &
search commented discussion "is:open is:pr archived:false commenter:@me -author:@me" 50 &
search assigned pr "is:open is:pr archived:false assignee:@me" 100 &
search requested pr "is:open is:pr archived:false user-review-requested:@me" 50 &
search mergedAuthored merged "is:pr is:merged archived:false author:@me merged:>=$yesterday" 50 &
search mergedReviewed merged "is:pr is:merged archived:false reviewed-by:@me merged:>=$yesterday" 50 &
wait

# A failed search leaves empty nodes; the sections it feeds say so in the menu.
failed='{}'
for file in "$tmp"/*.failed; do
  [[ -e $file ]] || continue
  name=$(basename "$file" .failed)
  error=$(grep -o 'gh: .*' "$file" | tail -1)
  failed=$(jq -c --arg n "$name" --arg e "${error:-unknown error}" '. + {($n): $e}' <<<"$failed")
done

if [[ $(jq length <<<"$failed") == 7 ]]; then
  json=$(<"$tmp/authored.failed")
  echo "GH !"
  echo "---"
  echo "gh api graphql failed | color=red"
  echo "${json//|//}"
  exit 0
fi

json=$(jq -s '
  reduce .[] as $r ({}; . * $r)
  | .data.authoredDiscussion.nodes as $disc
  # The two authored searches can disagree by a PR that just opened or closed.
  | .data.authored.nodes |= map(. as $pr
      | (first($disc[] | select(.url == $pr.url)) // {reviewThreads: {nodes: []}, comments: {nodes: []}}) as $d
      | $pr + $d + {commits: {nodes: [($pr.commits.nodes[0] // {}) * ($d.commits.nodes[0] // {})]}})
' "$tmp"/authored "$tmp"/authoredDiscussion "$tmp"/commented "$tmp"/assigned "$tmp"/requested "$tmp"/mergedAuthored "$tmp"/mergedReviewed)

# Merged-today notifications. Skipped when a merged search failed, so the next good run catches up.
# The first run ever seeds the seen list silently, otherwise every merge of the day would fire at once.
merged_failed=$(jq -r 'has("mergedAuthored") or has("mergedReviewed")' <<<"$failed")
if [[ $merged_failed == false ]]; then
  seen="$state_dir/seen-$today.txt"
  touch "$seen"
  seed=""
  if [[ ! -e $state_dir/.initialized ]]; then
    touch "$state_dir/.initialized"
    seed=1
  fi
  while IFS=$'\t' read -r url label title; do
    [[ -z $url ]] && continue
    grep -qxF "$url" "$seen" && continue
    if [[ -z $seed ]]; then
      open -g "$(jq -rn --arg b "$label · $title" --arg h "$url" \
        '"swiftbar://notify?plugin=github.10m.sh&title=PR%20merged&body=\($b | @uri)&href=\($h | @uri)"')"
    fi
    echo "$url" >>"$seen"
  done < <(jq -r --arg today "$today" '
    [.data.mergedAuthored.nodes[], .data.mergedReviewed.nodes[]]
    | unique_by(.url)
    | map(select(.mergedAt | fromdate | strflocaltime("%Y-%m-%d") == $today))
    | .[] | [.url, "\(.repository.name)#\(.number)", .title] | @tsv' <<<"$json")
  find "$state_dir" -name 'seen-*.txt' ! -name "seen-$today.txt" -delete
fi

# Hidden PRs whose snooze has not expired yet: {url: expires}.
now=$(date +%s)
hidden_json=$(awk -F'\t' -v now="$now" '$2 > now {print $1 "\t" $2}' "$hidden_file" 2>/dev/null |
  jq -Rsc 'split("\n") | map(select(. != "") | split("\t") | {key: .[0], value: (.[1] | tonumber)}) | from_entries')

# shellcheck disable=SC2016
jq -r --argjson failed "$failed" --argjson hidden "$hidden_json" --arg today "$today" --arg self "$self" '
def age($t): (now - ($t | fromdate)) as $s
  | if $s < 3600 then "\($s / 60 | floor)m"
    elif $s < 86400 then "\($s / 3600 | floor)h"
    else "\($s / 86400 | floor)d" end;
def who: if .login then .login else "@" + .slug end;
def ci: .commits.nodes[0].commit.statusCheckRollup.state;
def pending: [.reviewRequests.nodes[].requestedReviewer | select(. != null and . != {})];
def requested_at($r): . as $pr
  | [.timelineItems.nodes[] | select(.requestedReviewer != null and (.requestedReviewer | who) == ($r | who)) | .createdAt]
  | last // $pr.createdAt;
def clean: gsub("\\|"; "/") | gsub("\""; "'\''");
def cap($n): if length > $n then .[0:$n - 1] + "…" else . end;
def pad($n): . + ((" " * ($n - length)) // "");
def lpad($n): ((" " * ($n - length)) // "") + .;
# Jira keys and [scope] tags dropped from the title.
def short: .title | gsub("\\[[^\\]]*\\]"; "") | gsub("\\s+"; " ") | ltrimstr(" ") | rtrimstr(" ") | cap(40);
# Submenu under each PR row: snooze and hide, or wake when paused, or hide only when merged.
def snooze_lines($k):
  . as $pr
  | if $k == "paused" then ["--↺ wake | bash=\($self) param1=wake param2=\($pr.url) terminal=false"]
    else
      (if $k == "merged" then [] else ["30m", "1h", "2h", "1d", "2d"] end
       | map("--💤 \(.) | bash=\($self) param1=snooze param2=\($pr.url) param3=\(.) terminal=false"))
      + ["--✕ hide | bash=\($self) param1=snooze param2=\($pr.url) param3=hide terminal=false"]
    end;

.data.viewer.login as $me
| {login: $me} as $meref
| (.data.authored.nodes | map(select(.isDraft | not))) as $authored
| ($authored | map(. + {reason: (
      if .mergeStateStatus == "DIRTY" then "conflicts"
      elif ci == "FAILURE" or ci == "ERROR" then "CI failing"
      elif .reviewDecision == "CHANGES_REQUESTED" then "changes requested"
      elif .reviewDecision == "REVIEW_REQUIRED" and (pending | length) == 0 then "no reviewer pending, re-request"
      else null end)})
    | map(select(.reason))) as $action
| ($action | map(.url)) as $actionurls
| ([$authored[], (.data.assigned.nodes[] | select(.isDraft | not))]
    | unique_by(.url)
    | map(select(.mergeStateStatus == "CLEAN" or .mergeStateStatus == "HAS_HOOKS"))
    | map(select(.url as $u | $actionurls | index($u) | not))) as $ready
| ([.data.mergedAuthored.nodes[], .data.mergedReviewed.nodes[]]
    | unique_by(.url)
    | map(select(.mergedAt | fromdate | strflocaltime("%Y-%m-%d") == $today))
    | sort_by(.mergedAt) | reverse) as $merged
| (.data.requested.nodes | sort_by(requested_at($meref))) as $reviews
| ($authored
    | map(select(.reviewDecision == "REVIEW_REQUIRED" and (pending | length) > 0))
    | map(select(.url as $u | $actionurls | index($u) | not))) as $waiting
| def human: .author != null and .author.__typename != "Bot";
  def unanswered:
    (.author.login == $me) as $own
    | {threads: [.reviewThreads.nodes[]
          | select((.isResolved or .isOutdated) | not)
          | .comments.nodes as $c
          | select($own or any($c[]; .author.login == $me))
          | ($c | map(select(human)) | last)
          | select(. != null and .author.login != $me)],
       conv: (if $own then
          ([(.comments.nodes[] | select(.author.login == $me) | .createdAt), (.commits.nodes[0].commit.committedDate // empty)] | max) as $since
          | [.comments.nodes[] | select(human and .author.login != $me and .createdAt > $since)]
        else [] end)};
  ([.data.authored.nodes[], .data.commented.nodes[]]
    | unique_by(.url)
    | map(. + {pending: unanswered} | . + {pendingall: (.pending.threads + .pending.conv)})
    | map(select(.pendingall | length > 0))
    | sort_by(.pendingall | map(.createdAt) | min)) as $replies
| ([$action[], $ready[], $merged[], $reviews[], $waiting[], $replies[]] | map(.repository.owner.login) | unique | length == 1) as $strip
| def ref:
    if $strip then .repository.name | sub("^(adexchange-|terraform_adexchange_|victoria-metrics_|github-actions-)"; "")
    else .repository.nameWithOwner end;
  # Per-section columns after the title: who, age (right-aligned) and a free-form extra.
  # Menu row shows only the age: since the merge for merged rows, since creation otherwise.
  def fields($key):
    if $key == "merged" then {age: age(.mergedAt)}
    else {age: age(.createdAt)} end;
  # Tooltip carries the detail the row no longer shows: full reviewer list, or the action reason.
  def tip($key):
    if $key == "waiting" then . as $pr | pending | map(. as $r | "\(who) \($pr | age(requested_at($r)))") | join(", ")
    elif $key == "action" then .reason
    else "" end;
  def header:
    "\(.icon) \(.label)\(if .errors == [] then "" else " (failed, may be incomplete)" end)"
    + (if .url == "" then "" else " | href=\(.url)" end)
    + (if .errors != [] then " color=red tooltip=\"\(.errors | join(", ") | clean)\""
       elif .color then " color=\(.color)" else "" end);
  [
    {key: "action", icon: "🔧", label: "Needs my action", color: "red", prs: $action,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+author%3A%40me+archived%3Afalse+draft%3Afalse", src: ["authored"]},
    {key: "ready", icon: "🚀", label: "Ready to merge", prs: $ready,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+author%3A%40me+archived%3Afalse", src: ["authored", "assigned"]},
    {key: "merged", icon: "✅", label: "Merged today", prs: $merged,
     url: "https://github.com/pulls?q=is%3Apr+is%3Amerged+involves%3A%40me", src: ["mergedAuthored", "mergedReviewed"]},
    {key: "reviews", icon: "👀", label: "Review requested", prs: $reviews,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+user-review-requested%3A%40me+archived%3Afalse", src: ["requested"]},
    {key: "waiting", icon: "⏳", label: "Waiting for review", prs: $waiting,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+author%3A%40me+archived%3Afalse+draft%3Afalse+review%3Arequired", src: ["authored"]},
    {key: "replies", icon: "💬", label: "Unanswered comments", prs: $replies,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+involves%3A%40me+archived%3Afalse", src: ["authored", "authoredDiscussion", "commented"]}
  ]
  | map(. + {errors: [.src[] | $failed[.] // empty] | unique})
  | map(select((.prs | length > 0) or (.errors | length > 0)))
  | map(.key as $key | .prs |= map(. + {cells: ({ref: ("#\(.number)" as $n | (ref | cap(20 - ($n | length))) + $n), title: short} + fields($key)),
                                      tip: tip($key)}))
  # Snoozed or hidden PRs leave their section and move to the Paused one, which shows when they return.
  | . as $all
  | ([$all[] | .prs[] | select(.url as $u | $hidden | has($u))] | unique_by(.url)
      | map(. + {cells: (.cells + {age: ($hidden[.url] as $t
            | if $t >= 4102444800 then "hidden" else ($t | localtime | strftime("%a %H:%M")) end)})})) as $paused
  | ($all | map(. + {prs: [.prs[] | select(.url as $u | $hidden | has($u) | not)]})
      | map(select(.prs | length > 0 or .errors != []))) as $visible
  | ($visible + (if $paused == [] then [] else [{key: "paused", icon: "💤", label: "Paused", prs: $paused, errors: [], url: ""}] end)) as $sections
  # Column widths are shared across all sections so every row lines up; empty columns drop out.
  | ["ref", "title", "age"] as $cols
  | ([$sections[].prs[].cells] as $all | $cols | map({key: ., value: ([$all[][.] | length] | max)}) | from_entries) as $w
  | def line:
      .cells as $c
      | [$cols[] | select($w[.] > 0) | . as $k | $c[$k] | if $k == "age" then lpad($w[$k]) else pad($w[$k]) end]
      | join("  ") | clean;
  (if $visible == [] then "✓"
   else $visible | map("\(.icon) \(if .errors == [] then .prs | length else "!" end)") | join(" ") end),
    ($sections[]
      | . as $sec
      | "---",
        header,
        ($sec.prs[] | . as $pr
          | "\(line) | href=\(.url) tooltip=\"\(.title | clean)\(if .tip == "" then "" else " · " + (.tip | clean) end)\" font=.AppleSystemUIFontMonospaced size=12 symbolize=false",
            ($pr | snooze_lines($sec.key))[]))
' <<<"$json"
echo "---"
echo "Refresh | refresh=true"
