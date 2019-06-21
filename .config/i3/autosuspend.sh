status=`cat /sys/class/power_supply/BAT0/status`

if [ $status == "Discharging" ]
then
	systemctl suspend
fi

#echo $status
