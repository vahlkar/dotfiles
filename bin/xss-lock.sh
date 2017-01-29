#!/bin/bash
killall -q xss-lock
xss-lock -- /usr/bin/i3lock -n -fi ~/.wallpaper-lock &
