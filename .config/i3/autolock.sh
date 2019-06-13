#!/bin/bash

export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

/opt/xidlehook/xidlehook \
	--not-when-fullscreen \
	--not-when-audio \
	--timer normal 60 \
	'xrandr --output "$PRIMARY_DISPLAY" --brightness .5' \
	'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
	--timer primary 10 \
	'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; $HOME/.config/i3/i3lock.sh' \
	'' \
	--timer normal 1800 \
	'$HOME/.config/i3/autosuspend.sh' \
	''
