#!/bin/bash

PC_MONITOR="eDP-1"
EXTERNAL_MONITOR="$(xrandr | grep ' connected' | grep -v $PC_MONITOR | cut -d ' ' -f 1)"
PRIMARY="$(xrandr | grep 'primary' | cut -d ' ' -f 1)"

if [ "$PRIMARY" == "$PC_MONITOR" ]; then
    echo "Switching to external monitor"
    xrandr --output "$EXTERNAL_MONITOR" --auto --primary
    xrandr --output "$PC_MONITOR" --off
else
    echo "Switching to PC monitor"
    xrandr --output "$PC_MONITOR" --auto --primary
    xrandr --output "$EXTERNAL_MONITOR" --off
fi

# Adjust wallpaper again
$HOME/bin/feh_wallpaper.sh
