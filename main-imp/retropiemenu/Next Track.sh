#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# FULL MODE Write to Disk - LITE MODE Write to tmpfs - Recall Last Track/Position Lost on REBOOT using LITE MODE
if [ $(cat $IMPSettings/lite.flag) == "0" ]; then
	currentTRACK=$IMPPlaylist/current-track
else
	currentTRACK=/dev/shm/current-track
fi

if [[ $(cat $IMPSettings/music-switch.flag) == "1" || $(cat $IMPSettings/pause.flag) == "1" ]]; then
	pkill -STOP mpg123  > /dev/null 2>&1
	
	echo "" >> $currentTRACK
	echo -e '> 0000+0000  00:00.' >> $currentTRACK

	# Kill mpg123 to go to Next Track in Playlist
	pkill -KILL mpg123 > /dev/null 2>&1
	sleep 0.1
	tput reset
	exit 0
else
	# Full Stop
	bash $IMP/stop.sh

	# Call [play.sh] to start from Last Track
	bash $IMP/play.sh
	sleep 0.1

	# Kill mpg123 to go to Next Track in Playlist
	pkill -KILL mpg123 > /dev/null 2>&1
	sleep 0.1
	tput reset
	exit 0
fi
