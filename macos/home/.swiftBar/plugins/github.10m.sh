#!/bin/bash
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# GitHub PR summary; only sections with PRs are shown:
#   🔧 my PRs blocked on me (conflicts, CI failing, changes requested, nobody asked to review)
#   🚀 my or assigned PRs ready to merge (merge state CLEAN or HAS_HOOKS)
#   👀 PRs where I am requested as reviewer by name (team requests excluded)
#   ⏳ my PRs waiting on a pending reviewer
#   💬 open review threads whose last human comment is not mine (on my PRs, or
#      threads I took part in on others' PRs), plus newer comments on my PRs
# Hold Option on a PR row to copy its URL instead of opening it.

export PATH="/opt/homebrew/bin:$PATH"
unset GH_TOKEN GITHUB_TOKEN

if [[ $1 == copy ]]; then
  printf %s "$2" | pbcopy
  exit 0
fi

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
  number title url
  repository { name nameWithOwner owner { login } }
  author { login }
  commits(last: 1) { nodes { commit { committedDate } } }
  reviewThreads(first: 50) {
    nodes { isResolved isOutdated comments(first: 20) { nodes { author { __typename login } createdAt } } }
  }
  comments(last: 20) { nodes { author { __typename login } createdAt } }
}'

# One big query runs past GitHub's ~10s GraphQL timeout (502/504), so each
# search is its own request, run in parallel and retried once.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

search() { # name fragment spread search first
  local fragment=$pr_fragment
  [[ $2 == discussion ]] && fragment=$discussion_fragment
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
wait

# A failed search leaves empty nodes; the sections it feeds say so in the menu.
failed='{}'
for file in "$tmp"/*.failed; do
  [[ -e $file ]] || continue
  name=$(basename "$file" .failed)
  error=$(grep -o 'gh: .*' "$file" | tail -1)
  failed=$(jq -c --arg n "$name" --arg e "${error:-unknown error}" '. + {($n): $e}' <<<"$failed")
done

if [[ $(jq length <<<"$failed") == 5 ]]; then
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
' "$tmp"/authored "$tmp"/authoredDiscussion "$tmp"/commented "$tmp"/assigned "$tmp"/requested)

# shellcheck disable=SC2016
jq -r --argjson failed "$failed" --arg self "$(cd "$(dirname "$0")" && pwd)/$(basename "$0")" '
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
def cimark: {"SUCCESS": "CI ✓", "FAILURE": "CI ✗", "ERROR": "CI ✗", "PENDING": "CI …", "EXPECTED": "CI …"}[ci // ""] // empty;

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
| ([$action[], $ready[], $reviews[], $waiting[], $replies[]] | map(.repository.owner.login) | unique | length == 1) as $strip
| def ref:
    if $strip then .repository.name | sub("^(adexchange-|terraform_adexchange_|victoria-metrics_|github-actions-)"; "")
    else .repository.nameWithOwner end;
  def author: if .author.login == $me then "" else "@\(.author.login)" end;
  # Per-section columns after the title: who, age (right-aligned) and a free-form extra.
  def fields($key):
    if $key == "action" then {who: "", age: "", extra: (.reason | if startswith("no reviewer") then "re-request" else . end)}
    elif $key == "ready" then {who: author, age: "", extra: ""}
    elif $key == "reviews" then {who: author, age: age(requested_at($meref)),
      extra: (["+\(.additions) −\(.deletions)", cimark] | map(select(. != "")) | join("  "))}
    elif $key == "replies" then
      def count($n; $word): if $n == 0 then "" elif $n == 1 then "1 \($word)" else "\($n) \($word)s" end;
      {who: (.pendingall | map("@" + .author.login) | unique | join(", ")), age: (.pendingall | age(map(.createdAt) | max)),
       extra: ([count(.pending.threads | length; "thread"), count(.pending.conv | length; "comment")] | map(select(. != "")) | join(", "))}
    else . as $pr | pending as $p
      | {who: "\($p[0] | who)\(if ($p | length) > 1 then " +\(($p | length) - 1)" else "" end)",
         age: age($p | map(. as $r | $pr | requested_at($r)) | min), extra: ""} end
    | .who |= cap(21);
  # Full reviewer list for the tooltip, since the waiting row shows only the first one.
  def tip($key):
    if $key == "waiting" then . as $pr | pending | map(. as $r | "\(who) \($pr | age(requested_at($r)))") | join(", ")
    else "" end;
  [
    {key: "action", icon: "🔧", label: "Needs my action", color: "red", prs: $action,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+author%3A%40me+archived%3Afalse+draft%3Afalse", src: ["authored"]},
    {key: "ready", icon: "🚀", label: "Ready to merge", prs: $ready,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+author%3A%40me+archived%3Afalse", src: ["authored", "assigned"]},
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
  | . as $sections
  # Column widths are shared across all sections so every row lines up; empty columns drop out.
  | ["ref", "title", "who", "age"] as $cols
  | ([$sections[].prs[].cells] as $all | $cols | map({key: ., value: ([$all[][.] | length] | max)}) | from_entries) as $w
  | def line:
      .cells as $c
      | ([$cols[] | select($w[.] > 0) | . as $k | $c[$k] | if $k == "age" then lpad($w[$k]) else pad($w[$k]) end]
         + (if $c.extra == "" then [] else [$c.extra] end))
      | join("  ") | clean;
  (if $sections == [] then "✓"
   else $sections | map("\(.icon) \(if .errors == [] then .prs | length else "!" end)") | join(" ") end),
    ($sections[]
      | "---",
        if .errors == [] then "\(.icon) \(.label) | href=\(.url)\(if .color then " color=\(.color)" else "" end)"
        else "\(.icon) \(.label) (failed, may be incomplete) | href=\(.url) color=red tooltip=\"\(.errors | join(", ") | clean)\"" end,
        (.prs[] | "\(line) | href=\(.url) tooltip=\"\(.title | clean)\(if .tip == "" then "" else " · " + (.tip | clean) end)\" font=.AppleSystemUIFontMonospaced size=12 symbolize=false",
                  "\(ref)#\(.number) copy URL | alternate=true bash=\($self) param1=copy param2=\(.url) terminal=false"))
' <<<"$json"
echo "---"
echo "Refresh | refresh=true"
