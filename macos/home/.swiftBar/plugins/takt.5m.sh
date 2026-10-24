#!/usr/bin/env bash

# <xbar.title>Takt: time manager</xbar.title>
# <xbar.version>v0.2</xbar.version>
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
# SwiftBar does not load the shell profile, so takt would fall back to 8h.
export TAKT_TARGET_HOURS=7.5
target_min=450
week_target_min=$((5 * target_min))
green="color=#2e7d32,#81c784"
orange="color=#e65100,#ffb74d"

# takt prints durations like 4d10h36m or +1d1h36m, but "d" means 24h in the
# Total column and one target day (7h30) in the Balance column.
to_min() {
	local v=${1#[+-]} day_len=$2 sign=1 d=0 h=0 m=0
	[[ $1 == -* ]] && sign=-1
	[[ $v == *d* ]] && { d=${v%%d*}; v=${v#*d}; }
	[[ $v == *h* ]] && { h=${v%%h*}; v=${v#*h}; }
	[[ $v == *m* ]] && m=${v%m}
	echo $((sign * (10#$d * day_len + 10#$h * 60 + 10#$m)))
}

fmt() {
	local v=$1 sign=$2
	local s=""
	((v < 0)) && { s="-"; v=$((-v)); }
	[[ -n $sign && -z $s ]] && s="+"
	printf "%s%dh%02d" "$s" $((v / 60)) $((v % 60))
}

# Prints "label total balance days avg" per row with totals in plain hours.
rows() {
	$takt "$1" "$2" | tail -n +2 | while read -r date total days avg balance; do
		printf "%-9s %8s %8s %3sd %6s\n" "$date" \
			"$(fmt "$(to_min "$total" 1440)")" \
			"$(fmt "$(to_min "$balance" "$target_min")" +)" \
			"$days" "$(fmt "$(to_min "$avg" 1440)")"
	done
}

read -r last_ts status < <($takt cat 1 | tail -1)

read -r day_date day_total < <($takt day 1 | tail -1 | awk '{print $1, $2}')
worked=0
[[ $day_date == $(date +%F) ]] && worked=$(to_min "$day_total" 1440)

# Overtime bank since bank_since, excluding today. Computed from totals, not
# takt's Balance column, so it does not depend on TAKT_TARGET_HOURS. Today's
# target moves by at most bank_step until the bank is back to zero.
bank_since=2026-01-01
bank_step=60
bank=$($takt day 400 | tail -n +2 | awk -v s="$bank_since" -v t="$(date +%F)" '$1 >= s && $1 < t {print $2}' |
	while read -r t; do to_min "$t" 1440; done | awk -v tgt="$target_min" '{s += $1 - tgt} END {print s + 0}')
step=$bank
((step > bank_step)) && step=$bank_step
((step < -bank_step)) && step=-$bank_step
day_target=$((target_min - step))
balance=$((worked - day_target))

# Title
if ((balance >= 0)); then
	echo "$(fmt $worked) | $green"
else
	echo "$(fmt $worked)"
fi
echo "---"

# Today
tooltip=""
[[ $status == in ]] && tooltip=" tooltip=\"entrada ${last_ts:11:5}\""
filled=$((worked * 10 / day_target))
((filled > 10)) && filled=10
bar=""
for ((i = 0; i < 10; i++)); do
	((i < filled)) && bar+="▓" || bar+="░"
done
if ((balance >= 0)); then
	echo "hoy  $bar $(fmt $balance +)  $(fmt $worked) | font=Menlo $orange$tooltip"
	echo "objetivo $(fmt $day_target) · cumplido $(fmt $balance +)"
else
	echo "hoy  $bar  $(fmt $worked) | font=Menlo$tooltip"
	left="objetivo $(fmt $day_target) · falta $(fmt $((-balance)))"
	[[ $status == in ]] && left+=" · salida $(date -v+"$((-balance))"M +%H:%M)"
	echo "$left"
fi
if ((bank > 0)); then
	echo "banco $(fmt $bank +) desde $bank_since · −$(fmt $step)/día · ~$(((bank + bank_step - 1) / bank_step)) días"
elif ((bank < 0)); then
	echo "deuda $(fmt $bank) desde $bank_since · +$(fmt $((-step)))/día · ~$(((-bank + bank_step - 1) / bank_step)) días"
else
	echo "banco a cero desde $bank_since"
fi
echo "---"

# Week as one bar per weekday, scaled to 10h
monday=$(date -v-"$(($(date +%u) - 1))"d +%F)
today=$(date +%F)
day_rows=$($takt day 7)
week_min=0
worked_days=0
glyphs=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
bars=""
for i in 0 1 2 3 4; do
	d=$(date -j -v+"${i}"d -f %F "$monday" +%F)
	t=$(awk -v d="$d" '$1 == d {print $2}' <<<"$day_rows")
	if [[ -z $t || $d > $today ]]; then
		bars+=" ·  "
		continue
	fi
	m=$(to_min "$t" 1440)
	week_min=$((week_min + m))
	((m > 0)) && worked_days=$((worked_days + 1))
	g=$((m * 8 / 600))
	((g > 7)) && g=7
	bars+=" ${glyphs[g]}  "
done
week_left=$((week_target_min - week_min))
if ((week_left > 0)); then
	week_note="faltan $(fmt $week_left)"
else
	week_note="cumplida $(fmt $((-week_left)) +)"
fi
echo "semana  $(fmt $week_min) · ${worked_days}/5 días · $week_note"
echo " L   M   X   J   V | font=Menlo"
echo "$bars | font=Menlo"
echo "---"

# Periods with history in submenus
period() {
	local icon=$1 label=$2 cmd=$3 n=$4
	read -r _ total days avg balance < <($takt "$cmd" 1 | tail -1)
	local line="$icon $label $(fmt "$(to_min "$total" 1440)") ($(fmt "$(to_min "$balance" "$target_min")" +))"
	[[ $cmd != day ]] && line+=" · $days días · $(fmt "$(to_min "$avg" 1440)")/día"
	echo "$line"
	rows "$cmd" "$n" | sed 's/$/ | font=Menlo/; s/^/--/'
	echo "-----"
	echo "--abrir en Terminal | bash=$takt param1=$cmd param2=$n terminal=true"
}
period 📆 día day 10
period 📅 semana week 8
period 🗓️ mes month 12
period 🗓️ año year 5
echo "---"
echo "📝 edit | bash=/Users/mgreco/.local/bin/gtty-nvim param1=/Users/mgreco/.takt-log/seedtag.csv terminal=false"
echo "⤴️ commit | bash=$takt param1=commit terminal=false"
echo "🔄 refresh | refresh=true"
