#!/bin/bash
killall -q xss-lock
xss-lock -- /usr/bin/i3lock -n -c 000000 -fi ~/.wallpaper-lock &
