#!/bin/zsh

sleep 5

rm /tmp/xidlehook.sock

export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"



/opt/xidlehook/xidlehook \
	--not-when-fullscreen \
	--socket /tmp/xidlehook.sock \
	--not-when-audio \
	--timer normal 60 \
	'~/.config/i3/brightnesscontrol.sh 20' \
	'pkill brightnesscontr' \
	--timer primary 30 \
	'$HOME/.config/i3/i3lock.sh;pkill brightnesscontr;~/.config/i3/brightnesscontrol.sh 1' \
	'pkill brightnesscontr' \
	--timer normal 1800 \
	'$HOME/.config/i3/autosuspend.sh' \
	''
