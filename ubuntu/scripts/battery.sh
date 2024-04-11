#!/bin/bash

# BAT=$(acpi -b | grep -E -o '[1-9][0-9]?%')
BAT=$(grep -P -o '(?<=^POWER_SUPPLY_CAPACITY=)\w*$' /sys/class/power_supply/BAT0/uevent)

# Full and short texts
# echo "Battery: $BAT"
echo "  $BAT"

# Set urgent flag below 5% or use orange below 20%
[ ${BAT%?} -le 5 ] && exit 33
[ ${BAT%?} -le 20 ] && echo "#FF8000"

exit 0
