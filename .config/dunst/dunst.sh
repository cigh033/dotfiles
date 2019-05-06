#!/bin/bash 

# Terminate already running bar instances
killall -q dunst

# Wait until the processes have been shut down
while pgrep -x dunst >/dev/null; do sleep 1; done

  dunst -config ~/.config/dunst/dunstrc main &>/dev/null &
