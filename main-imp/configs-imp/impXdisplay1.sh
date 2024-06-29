#!/bin/bash
# Runs @ES Wake

tput cnorm #Restore Cursor

# Issue on rPi4 where omxplayer will get Stuck L00PING the Same Video - KILL omxplayer @ES Wake
pkill -KILL omxplayer > /dev/null 2>&1

# Start Displays Indiscriminately
sleep 0.1
for connectedMON in $(xrandr --verbose 2>/dev/null | grep ' connected ' | awk '{print $1}'); do
	xrandr --output $connectedMON --auto > /dev/null 2>&1; sleep 0.1 # PowerON Display(s) for PC/0ther [xrandr]
done
xset dpms force on > /dev/null 2>&1 # PowerON Display for PC/0ther [xset]
vcgencmd display_power 1 > /dev/null 2>&1 # PowerON Display for Pi

# Restart ES on wake if ES Artwork + Video Snaps have issues after sleep/wake
touch /tmp/es-restart
pkill -f "/opt/retropie/supplementary/.*/emulationstation([^.]|$)" &

exit 0
