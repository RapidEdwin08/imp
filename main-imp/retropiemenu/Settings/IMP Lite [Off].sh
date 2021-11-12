#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist

if [[ $(cat $IMPSettings/lite.flag) == "1" ]]; then
	if [[ $(cat $IMPSettings/music-switch.flag) == "1" ]]; then
		# Stop mpg123loop
		bash "$IMP/stop.sh" continue > /dev/null 2>&1
		
		# Carry 0ver Current Track Contents to [Disk] for FULL MODE
		cat /dev/shm/current-track > $IMPPlaylist/current-track
		rm /dev/shm/current-track > /dev/null 2>&1
	
		# Turning LITE MODE Off
		echo "0" > $IMPSettings/lite.flag
		
		# Resume Playback
		bash "$IMP/play.sh" &
		exit 0
	fi
	
	if [[ ! $(cat $IMPSettings/pause.flag) == "0" ]]; then
		# Stop mpg123loop
		bash "$IMP/stop.sh" continue > /dev/null 2>&1
	fi
	
	# Carry 0ver Current Track Contents to [Disk] for FULL MODE
	cat /dev/shm/current-track > $IMPPlaylist/current-track
	rm /dev/shm/current-track > /dev/null 2>&1
	
	# Turning LITE MODE Off
	echo "0" > $IMPSettings/lite.flag
fi

tput reset
exit 0
