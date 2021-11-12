#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist

if [[ $(cat $IMPSettings/lite.flag) == "0" ]]; then
	if [[ $(cat $IMPSettings/music-switch.flag) == "1" ]]; then
		# Stop mpg123loop
		bash "$IMP/stop.sh" continue > /dev/null 2>&1
		
		# Carry 0ver Current Track Contents to [tmpfs] for LITE MODE
		cat $IMPPlaylist/current-track > /dev/shm/current-track
		rm $IMPPlaylist/current-track > /dev/null 2>&1
	
		# Turning LITE MODE On
		echo "1" > $IMPSettings/lite.flag
		
		# Resume Playback
		bash "$IMP/play.sh" &
		exit 0
	fi
	
	if [[ ! $(cat $IMPSettings/pause.flag) == "0" ]]; then
		# Stop mpg123loop
		bash "$IMP/stop.sh" continue > /dev/null 2>&1
	fi
	
	# Carry 0ver Current Track Contents to [tmpfs] for LITE MODE
	cat $IMPPlaylist/current-track > /dev/shm/current-track
	rm $IMPPlaylist/current-track > /dev/null 2>&1
	
	# Turning LITE MODE On
	echo "1" > $IMPSettings/lite.flag
fi

tput reset
exit 0
