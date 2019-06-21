#!/bin/zsh

sleep 5

rm /tmp/xidlehook.sock

export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"



/opt/xidlehook/xidlehook \
	--not-when-fullscreen \
	--socket /tmp/xidlehook.sock \
	--not-when-audio \
	--timer normal 30 \
	'xbacklight -get > /tmp/xbacklightvalue; xbacklight -set 50' \
	'xbacklight -set $(cat /tmp/xbacklightvalue)' \
	--timer primary 10 \
	'if [ $(xbacklight -get | cut -d "." -f 1) -gt 49 ];then xbacklight -get > /tmp/xbacklightvalue;fi; xbacklight -set 30;$HOME/.config/i3/i3lock.sh' \
	'xbacklight -set $(cat /tmp/xbacklightvalue)' \
	--timer normal 1800 \
	'$HOME/.config/i3/autosuspend.sh' \
	''
