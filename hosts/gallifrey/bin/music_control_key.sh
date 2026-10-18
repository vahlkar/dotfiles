#!/bin/bash
if [ $# -eq 1 ]
then
	player=`ps -u volodia | grep -c clementine`
	if [ $player -gt 0 ]
	then
		if [ $1 = "--play-pause" ]
		then
			clementine --play-pause
		elif [ $1 = "--previous" ]
		then
			clementine --previous
		elif [ $1 = "--next" ]
		then
			clementine --next
		elif [ $1 = "--stop" ]
		then
			clementine --stop
		fi
	fi

	player=`ps -u volodia | grep -c guayadeque`
	if [ $player -gt 0 ]
	then
		if [ $1 = "--play-pause" ]
		then
			dbus-send --print-reply --type=method_call --dest=org.mpris.guayadeque /Player org.freedesktop.MediaPlayer.Pause
		elif [ $1 = "--previous" ]
		then
			dbus-send --print-reply --type=method_call --dest=org.mpris.guayadeque /Player org.freedesktop.MediaPlayer.Prev
		elif [ $1 = "--next" ]
		then
			dbus-send --print-reply --type=method_call --dest=org.mpris.guayadeque /Player org.freedesktop.MediaPlayer.Next
		elif [ $1 = "--stop" ]
		then
			dbus-send --print-reply --type=method_call --dest=org.mpris.guayadeque /Player org.freedesktop.MediaPlayer.Stop
		fi
	fi
fi
