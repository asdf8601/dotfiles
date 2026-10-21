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

query='
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
}
fragment discussion on PullRequest {
  number title url
  repository { name nameWithOwner owner { login } }
  author { login }
  commits(last: 1) { nodes { commit { committedDate } } }
  reviewThreads(first: 50) {
    nodes { isResolved isOutdated comments(first: 20) { nodes { author { __typename login } createdAt } } }
  }
  comments(last: 20) { nodes { author { __typename login } createdAt } }
}
query {
  viewer { login }
  authored: search(query: "is:open is:pr archived:false author:@me", type: ISSUE, first: 100) {
    nodes { ...pr ...discussion }
  }
  commented: search(query: "is:open is:pr archived:false commenter:@me -author:@me", type: ISSUE, first: 50) {
    nodes { ...discussion }
  }
  assigned: search(query: "is:open is:pr archived:false assignee:@me", type: ISSUE, first: 100) {
    nodes { ...pr }
  }
  requested: search(query: "is:open is:pr archived:false user-review-requested:@me", type: ISSUE, first: 50) {
    nodes { ...pr }
  }
}'

if ! json=$(gh api graphql -f query="$query" 2>&1); then
  echo "GH !"
  echo "---"
  echo "gh api graphql failed | color=red"
  echo "${json//|//}"
  exit 0
fi

# shellcheck disable=SC2016
jq -r --arg self "$(cd "$(dirname "$0")" && pwd)/$(basename "$0")" '
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
def short: if (.title | length) > 70 then .title[0:69] + "…" else .title end | clean;
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
| def row(meta):
    (if $strip then .repository.name else .repository.nameWithOwner end) as $ref
    | "\($ref)#\(.number) \(short)\(if meta == "" then "" else " · " + meta end) | href=\(.url) tooltip=\"\(.title | clean)\" symbolize=false",
      "\($ref)#\(.number) copy URL | alternate=true bash=\($self) param1=copy param2=\(.url) terminal=false";
  def author: if .author.login == $me then "" else "@\(.author.login)" end;
  def meta($key):
    if $key == "action" then .reason
    elif $key == "ready" then author
    elif $key == "replies" then
      def count($n; $word): if $n == 0 then "" elif $n == 1 then "1 \($word)" else "\($n) \($word)s" end;
      [author, count(.pending.threads | length; "thread"), count(.pending.conv | length; "comment"),
       (.pendingall | "\(map("@" + .author.login) | unique | join(", ")) \(age(map(.createdAt) | max))")]
      | map(select(. != "")) | join(" · ")
    elif $key == "reviews" then [author, "asked \(age(requested_at($meref)))", "+\(.additions) −\(.deletions)", cimark] | map(select(. != "")) | join(" · ")
    else . as $pr | pending | map(. as $r | "\(who) \($pr | age(requested_at($r)))") | join(", ") end;
  [
    {key: "action", icon: "🔧", label: "Needs my action", color: "red", prs: $action,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+author%3A%40me+archived%3Afalse+draft%3Afalse"},
    {key: "ready", icon: "🚀", label: "Ready to merge", prs: $ready,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+author%3A%40me+archived%3Afalse"},
    {key: "reviews", icon: "👀", label: "Review requested", prs: $reviews,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+user-review-requested%3A%40me+archived%3Afalse"},
    {key: "waiting", icon: "⏳", label: "Waiting for review", prs: $waiting,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+author%3A%40me+archived%3Afalse+draft%3Afalse+review%3Arequired"},
    {key: "replies", icon: "💬", label: "Unanswered comments", prs: $replies,
     url: "https://github.com/pulls?q=is%3Aopen+is%3Apr+involves%3A%40me+archived%3Afalse"}
  ]
  | map(select(.prs | length > 0)) as $sections
  | (if $sections == [] then "✓" else $sections | map("\(.icon) \(.prs | length)") | join(" ") end),
    ($sections[] | .key as $key
      | "---", "\(.icon) \(.label) | href=\(.url)\(if .color then " color=\(.color)" else "" end)",
        (.prs[] | row(meta($key))))
' <<<"$json"
echo "---"
echo "Refresh | refresh=true"
