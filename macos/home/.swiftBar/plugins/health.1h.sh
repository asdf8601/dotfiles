#!/bin/bash
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# Health of the adserving services, once an hour:
#   - each DC's own VictoriaMetrics (vmselect-vmstack-localcluster, reached with a
#     kubectl port-forward on a free local port that closes after the queries):
#     5xx ratio, pods unavailable, restarts and OOM kills
#   - Cloud Monitoring's log_entry_count/byte_count per container and severity,
#     the last hour against the median of the same hour over the last 7 days
#   - for a service whose logs spike, the messages that dominate a sample
# Title: a shield icon; red text for what is broken, orange icon for warnings.
# Rollouts tracked by rollout.10s.sh in the last 90 min turn log flags grey.

export PATH="/opt/homebrew/bin:$PATH"

# deployment (also its container name), short name, recording-rule prefix
# ("-" when the service has no HTTP rule), floor for ERROR/WARNING per min
services='
ssp-service                    ssp  ssp                     300
buying-engine-service          be   -                       30
reserve-price-service          rp   reserve_price           30
header-bidding-pricing-service hbp  header_bidding_pricing  10
ad-unit-kpi-service            kpi  ad_unit_kpi             10
'
dcs="euw usc usw use ase"
project=maximal-record-121815
cache=~/.cache/health
mkdir -p "$cache/vm" "$cache/logs" "$cache/top"

svcs_json=$(awk 'NF { printf "%s{\"dep\":\"%s\",\"short\":\"%s\",\"rule\":\"%s\",\"floor\":%s}", (n++ ? "," : "["), $1, $2, $3, $4 } END { print "]" }' <<<"$services")
deps=$(jq -r 'map(.dep) | join("|")' <<<"$svcs_json")

# Queries one DC's vmselect through a port-forward on a port kubectl picks.
fetch_vm() {
  local dc=$1 out=$cache/vm/$1 log port pf i
  log=$(mktemp)
  kubectl --context "$dc" -n victoriametrics port-forward svc/vmselect-vmstack-localcluster :8481 >"$log" 2>&1 &
  pf=$!
  for i in $(seq 1 100); do
    port=$(sed -n 's/^Forwarding from 127.0.0.1:\([0-9]*\).*/\1/p' "$log" | head -1)
    [[ -n $port ]] && break
    kill -0 $pf 2>/dev/null || break
    sleep 0.1
  done
  if [[ -z $port ]]; then
    jq -cn --arg dc "$dc" --arg err "$(grep -v '^Forwarding' "$log" | head -1)" '{dc: $dc, error: ($err | if . == "" then "port-forward timed out" else . end)}' >"$out.tmp"
  else
    q() { curl -s -m 20 -G "localhost:$port/select/0/prometheus/api/v1/query" --data-urlencode "query=$1" | jq -c '[.data.result[] | {k: (.metric.deployment // .metric.container // ""), v: (.value[1] | tonumber)}]'; }
    local sel="namespace=\"default\",deployment=~\"$deps\"" csel="namespace=\"default\",container=~\"$deps\""
    local osel="$csel,reason=\"OOMKilled\""
    local fivexx='{}' rule r
    while read -r dep short rule floor; do
      [[ -z $dep || $rule == - ]] && continue
      r="by_${rule}_service_path_status_code:http_request_duration_seconds_count:rate_2m"
      fivexx=$(jq -c --arg d "$dep" --argjson avg "$(q "(sum(avg_over_time(${r}{status_code=~\"5..\"}[1h])) or vector(0)) / sum(avg_over_time(${r}[1h]))")" \
        --argjson peak "$(q "max_over_time(((sum(${r}{status_code=~\"5..\"}) or vector(0)) / sum(${r}))[1h:5m])")" \
        '. + {($d): {avg: ($avg[0].v // null), peak: ($peak[0].v // null)}}' <<<"$fivexx")
    done <<<"$services"
    # Unavailable for the whole last 20 min, so rollouts and spot churn pass.
    jq -cn --arg dc "$dc" --argjson fivexx "$fivexx" \
      --argjson unavail "$(q "min_over_time((kube_deployment_status_replicas_unavailable{$sel} / on(deployment) kube_deployment_spec_replicas{$sel})[20m:5m])")" \
      --argjson restarts "$(q "sum by (container) (increase(kube_pod_container_status_restarts_total{$csel}[1h]))")" \
      --argjson oom "$(q "sum by (container) (kube_pod_container_status_last_terminated_reason{$osel} * on(namespace,pod,container) (increase(kube_pod_container_status_restarts_total{$csel}[1h]) > 0))")" \
      'def m: map({(.k): .v}) | add // {};
       {dc: $dc, fivexx: $fivexx, unavail: ($unavail | m), restarts: ($restarts | m), oom: ($oom | m)}' >"$out.tmp"
  fi
  kill $pf 2>/dev/null
  wait $pf 2>/dev/null
  rm -f "$log"
  mv "$out.tmp" "$out.json"
}

# One Monitoring API call: per container and severity, the sum over the hour
# ending $2 days ago.
fetch_log_metric() {
  local metric=$1 days=$2 token=$3 end start
  end=$(date -u -v-"${days}"d +%Y-%m-%dT%H:%M:00Z)
  start=$(date -u -v-"${days}"d -v-1H +%Y-%m-%dT%H:%M:00Z)
  curl -s -m 60 -G "https://monitoring.googleapis.com/v3/projects/$project/timeSeries" \
    -H "Authorization: Bearer $token" \
    --data-urlencode "filter=metric.type=\"logging.googleapis.com/$metric\" AND resource.type=\"k8s_container\" AND resource.labels.namespace_name=\"default\" AND resource.labels.container_name=one_of($(jq -r 'map("\"" + .dep + "\"") | join(",")' <<<"$svcs_json"))" \
    --data-urlencode "interval.startTime=$start" --data-urlencode "interval.endTime=$end" \
    --data-urlencode aggregation.alignmentPeriod=3600s --data-urlencode aggregation.perSeriesAligner=ALIGN_SUM \
    --data-urlencode aggregation.crossSeriesReducer=REDUCE_SUM \
    --data-urlencode aggregation.groupByFields=resource.labels.container_name \
    --data-urlencode aggregation.groupByFields=metric.labels.severity |
    jq -c --arg m "$metric" --argjson d "$days" \
      '{metric: $m, days: $d, error: .error.message,
        rows: [.timeSeries[]? | {dep: .resource.labels.container_name, sev: .metric.labels.severity,
               v: (.points[0].value.int64Value | tonumber)}]}' >"$cache/logs/$metric.$days.json"
}

fetch_logs() {
  local token metric d
  if ! token=$(gcloud auth print-access-token 2>&1); then
    jq -cn --arg err "$(tail -1 <<<"$token")" '{metric: "log_entry_count", days: 0, error: $err, rows: []}' >"$cache/logs/log_entry_count.0.json"
    return
  fi
  for metric in log_entry_count byte_count; do
    for d in 0 1 2 3 4 5 6 7; do fetch_log_metric $metric $d "$token" & done
  done
  wait
}

# The messages that dominate a sample of WARNING and above over the last $3 min.
fetch_top() {
  local dep=$1 rate=$2 mins=$3 since
  since=$(date -u -v-"${mins}"M +%Y-%m-%dT%H:%M:%SZ)
  gcloud logging read "resource.type=\"k8s_container\" AND resource.labels.container_name=\"$dep\" AND severity>=WARNING AND timestamp>=\"$since\" AND sample(insertId, $rate)" \
    --project=$project --limit=2000 --format=json 2>/dev/null |
    jq -c --arg dep "$dep" --argjson rate "$rate" --argjson mins "$mins" \
      '{dep: $dep, rate: $rate, mins: $mins, n: length, top: (map({sev: .severity,
          msg: (.jsonPayload.msg // .jsonPayload.event
                // (.jsonPayload.message | if type == "object" then (.event // tostring) else . end)
                // .textPayload // "?") | tostring | gsub("\\s+"; " ") | .[0:90]})
        | group_by([.sev, .msg]) | map({sev: .[0].sev, msg: .[0].msg, n: length}) | sort_by(-.n) | .[0:5])}' \
      >"$cache/top/$dep.json"
}

# Per service: VM signals per DC, log rates per min now and as the median of
# the same hour on the 7 days before, and the flags they raise.
model='
def med: sort | if length == 0 then 0 else .[length / 2 | floor] end;
def per_min: . / 60;
($logs | map(select(.metric == "log_entry_count"))) as $entries
| ($logs | map(select(.metric == "byte_count"))) as $bytes
| def rate($set; $dep; sev; $d): [$set[] | select(.days == $d) | .rows[] | select(.dep == $dep and sev) | .v] | add // 0 | per_min;
  def now_med($set; $dep; sev): {now: rate($set; $dep; sev; 0), med: ([range(1; 8) as $d | rate($set; $dep; sev; $d)] | med)};
  ([$rollout[] | arrays | .[] | select(.start and ($now - (.start | fromdateiso8601)) < 5400) | .app] | unique) as $rolled
| [$svcs[] as $sv
   | [$vm[] | {dc, error, fivexx: .fivexx[$sv.dep], unavail: .unavail[$sv.dep], restarts: .restarts[$sv.dep], oom: .oom[$sv.dep]}] as $dcs
   | {err: now_med($entries; $sv.dep; .sev == "ERROR"),
      warn: now_med($entries; $sv.dep; .sev == "WARNING"),
      total: now_med($entries; $sv.dep; true),
      bytes: now_med($bytes; $sv.dep; true)} as $l
   | ([$dcs[] | .fivexx.peak // empty] | max) as $peak
   | ([$dcs[] | .unavail // empty] | max) as $unav
   | ([$dcs[] | .restarts // 0] | add) as $rst
   | ([$dcs[] | .oom // 0] | add) as $oom
   | def spike($x; $k; $floor): $x.now > $k * $x.med and $x.now > $floor;
     (($rolled | index($sv.dep)) != null) as $rollout
   | {sv: $sv, dcs: $dcs, logs: $l, peak: $peak, unav: $unav, restarts: $rst, oom: $oom, rollout: $rollout,
      top: ($top | map(select(.dep == $sv.dep)) | .[0]),
      red: ([if ($peak // 0) > 0.02 then "5xx \($peak * 100 | floor)%" else empty end,
             if ($unav // 0) > 0.10 then "unavail \($unav * 100 | floor)%" else empty end,
             if $rollout | not then
               (if spike($l.err; 3; $sv.floor) then "ERR ×\($l.err.now / ([$l.err.med, 0.1] | max) | floor)" else empty end,
                if spike($l.warn; 3; $sv.floor) then "WARN ×\($l.warn.now / ([$l.warn.med, 0.1] | max) | floor)" else empty end)
             else empty end]),
      orange: ([if $oom > 0 then "OOM \($oom)" else empty end,
                if $rst > 10 then "restarts \($rst)" else empty end,
                if ($rollout | not) and (spike($l.total; 2; $sv.floor) or spike($l.bytes; 2; 0)) then "log volume" else empty end])}]'

run_model() {
  jq -n --argjson svcs "$svcs_json" --argjson now "$(date +%s)" \
    --slurpfile vm <(cat "$cache"/vm/*.json 2>/dev/null) \
    --slurpfile logs <(cat "$cache"/logs/*.json 2>/dev/null) \
    --slurpfile top <(cat "$cache"/top/*.json 2>/dev/null) \
    --slurpfile rollout <(cat ~/.cache/rollout/dc/*.json 2>/dev/null) \
    "$@"
}

fetch() {
  local dc dep
  rm -f "$cache"/top/*.json
  for dc in $dcs; do fetch_vm "$dc" & done
  fetch_logs &
  wait
  # Samples only the services whose ERROR or WARNING rate spiked: 1% of 10 min
  # of ssp-service, the last hour of the others, whose errors come in bursts.
  for dep in $(run_model -r "$model | .[] | select(any(.red[]; startswith(\"ERR\") or startswith(\"WARN\"))) | .sv.dep"); do
    if [[ $dep == ssp-service ]]; then fetch_top "$dep" 0.01 10 & else fetch_top "$dep" 1 60 & fi
  done
  wait
  date +%s >"$cache/checked"
}

fetch

checked=$(date -r "$(cat "$cache/checked")" +%H:%M)

run_model -r --arg checked "$checked" --arg project "$project" --arg k9s ~/.local/bin/gtty-k9s "$model"' |
def F: "font=.AppleSystemUIFontMonospaced size=12";
def pad(n): tostring | if length < n then . + (" " * (n - length)) else . end;
def lpad(n): tostring | if length < n then (" " * (n - length)) + . else . end;
def pct: if . == null then "–" else "\(. * 10000 | round / 100)%" end;
def num: if . >= 100 then "\(round)" elif . >= 10 then "\(. * 10 | round / 10)" else "\(. * 100 | round / 100)" end;
def x($m): if $m > 0 then "×\(. / $m * 10 | round / 10)" else "" end;
def rate_cell(w): . as $r | "\($r.now | num) \($r.now | x($r.med))" | lpad(w);
def mib: . / 1048576;
def logs_url($dep): "https://console.cloud.google.com/logs/query;query="
  + ("resource.type=\"k8s_container\"\nresource.labels.container_name=\"\($dep)\"\nseverity>=WARNING" | @uri)
  + "?project=\($project)";

. as $all
| ([$all[] | select((.red | length) > 0) | "\(.sv.short) \(.red | join(" "))"]) as $red
| (any($all[]; (.orange | length) > 0)) as $orange
| (any($all[].dcs[]; .error)) as $vm_err
| (if ($red | length) > 0 then "\($red | join(" · ")) | sfimage=exclamationmark.shield color=red"
   elif $orange or $vm_err then "| sfimage=exclamationmark.shield sfcolor=orange"
   else "| sfimage=checkmark.shield" end),
  "---",
  "\("svc" | pad(5))\("5xx" | lpad(7))\("unav" | lpad(7))\("rst" | lpad(5))\("ERR/min" | lpad(13))\("WARN/min" | lpad(13))\("MiB/min" | lpad(12)) | \(F) color=gray",
  ($all[] | . as $s
   | "\($s.sv.short | pad(5))\($s.peak | pct | lpad(7))\($s.unav | pct | lpad(7))\($s.restarts | tostring | lpad(5))"
     + ($s.logs.err | rate_cell(13)) + ($s.logs.warn | rate_cell(13))
     + ({now: ($s.logs.bytes.now | mib), med: ($s.logs.bytes.med | mib)} | rate_cell(12))
     + (if $s.rollout then "  rollout" else "" end)
     + " | \(F)"
     + (if ($s.red | length) > 0 then " color=red" elif ($s.orange | length) > 0 then " color=orange" else "" end),
     ($s.red + $s.orange | if length > 0 then "--\(join(" · ")) | \(F)" else empty end),
     ($s.dcs[] | " bash=\($k9s) param1=\(.dc) param2=\($s.sv.dep) terminal=false" as $k9s_click
       | if .error then "--\(.dc | pad(5))❌ \(.error | .[0:70]) | \(F) color=red\($k9s_click)"
       else "--\(.dc | pad(5))5xx \(.fivexx.peak | pct | lpad(6))  unav \(.unavail | pct | lpad(6))  rst \(.restarts // 0 | tostring | lpad(3))"
         + (if (.oom // 0) > 0 then "  OOM \(.oom)" else "" end) + " | \(F)\($k9s_click)" end),
     (if $s.top and ($s.top.top | length) > 0 then
        "-----",
        "--top WARNING+ (\($s.top.rate * 100)% of \($s.top.mins) min, \($s.top.n) entries) | \(F) color=gray",
        ($s.top.top[] | "--\(.n | tostring | lpad(5))  \(.sev | .[0:4] | pad(5))\(.msg | gsub("\\|"; "/")) | \(F) symbolize=false")
      else empty end),
     "-----",
     "--Open WARNING+ logs | href=\(logs_url($s.sv.dep))"),
  "---",
  "rates: last hour · ×: vs median of the same hour, 7 days | \(F) color=gray",
  "checked \($checked) | color=gray",
  "Refresh | refresh=true"
'
