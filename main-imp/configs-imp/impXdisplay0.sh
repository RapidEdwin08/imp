#!/bin/bash
# Runs @ES Sleep

# Issue on rPi4 where omxplayer will get Stuck L00PING the Same Video - KILL omxplayer @ES Sleep
pkill -KILL omxplayer > /dev/null 2>&1

# Stop Displays Indiscriminately
sleep 0.1
for connectedMON in $(xrandr --verbose 2>/dev/null | grep ' connected ' | awk '{print $1}'); do
	xrandr --output $connectedMON --off > /dev/null 2>&1; sleep 0.1 # PowerOFF Display(s) for PC/0ther [xrandr]
done
xset dpms force off > /dev/null 2>&1 # PowerOff Display for PC/0ther
vcgencmd display_power 0 > /dev/null 2>&1 # PowerOff Display for Pi

exit 0
