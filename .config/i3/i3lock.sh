rdpconnected=`xrandr | grep rdp0 | awk '{print $1}'`

if [ -z $rdpconnected ]

	then
		if ! pgrep -x "i3lock" > /dev/null
		then
			i3lock -i ~/Pictures/lockscreen.png -t
		fi


	fi
