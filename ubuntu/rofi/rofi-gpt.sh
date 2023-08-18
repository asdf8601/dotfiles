#!/bin/bash
# only prompt avoid history
INPUT=$(rofi -dmenu -config ~/.config/rofi/config.rasi -p "" -only-match)
# INPUT=$(rofi -dmenu -config ~/.config/rofi/config.rasi -p "")
# INPUT=$(rofi -dmenu -p "")
if [[ -z $INPUT ]]; then
    exit 1
fi

zenity --progress --text="Waiting for an answer" --pulsate &

if [[ $? -eq 1 ]]; then
    exit 1
fi

PID=$!

ANSWER=$(~/.local/bin/sgpt "$INPUT")
kill $PID
zenity --info --text="$ANSWER"
