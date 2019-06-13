#!/bin/bash
playerctl status &> .spotifyscript

if [ $? == 1 ]; then
    echo ""
elif [ "$(playerctl status)" == "Playing" ]; then
    title=`exec playerctl metadata title`
    artist=`exec playerctl metadata artist`
    echo "playing '$title' from '$artist'"
elif [ "$(playerctl status)" == "Paused" ]; then
    title=`exec playerctl metadata title`
    artist=`exec playerctl metadata artist`
    echo "paused '$title' from '$artist'"
else
    echo ""
fi
