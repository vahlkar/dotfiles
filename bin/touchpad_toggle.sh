#!/bin/bash

active=$(synclient -l | grep TouchpadOff | cut -d "=" -f 2)

if [ "$active" -eq 1 ]
then
    # Touchpad deactivated, activate it.
    synclient "TouchpadOff=0"
elif [ "$active" -eq 2 ]
then
    # Tap & Scrolling deactivated, activate the touchpad.
    synclient "TouchpadOff=0"
else
    # Touchpad activated, deactivate it.
    synclient "TouchpadOff=1"
fi
