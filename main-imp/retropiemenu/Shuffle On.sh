#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist

if [[ $(cat $IMPSettings/shuffle.flag) == "0" ]]; then
	# Turning SHUFFLE On
	echo "1" > $IMPSettings/shuffle.flag
	
	if [[ $(cat $IMPSettings/music-switch.flag) == "1" ]]; then
		# Stop mpg123loop with continue parameter
		bash "$IMP/stop.sh" continue > /dev/null 2>&1
		
		# Shuffle the Current Playlist
		sort --random-sort $IMPPlaylist/init > $IMPPlaylist/shuffle
	
		# Resume Playback
		bash "$IMP/play.sh" &
		exit 0
	fi
	
	if [[ ! $(cat $IMPSettings/pause.flag) == "0" ]]; then
		# Stop mpg123loop WITH continue parameter
		bash "$IMP/stop.sh" continue > /dev/null 2>&1
		
		# Shuffle the Current Playlist
		sort --random-sort $IMPPlaylist/init > $IMPPlaylist/shuffle
		
		# Set [pause.flag] 
		echo "1" > $IMPSettings/pause.flag
	fi
fi
	
tput reset
exit 0
