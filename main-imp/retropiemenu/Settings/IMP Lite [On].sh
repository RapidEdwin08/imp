#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist

if [[ $(cat $IMPSettings/lite.flag) == "0" ]]; then
	# Turning LITE MODE On
	echo "1" > $IMPSettings/lite.flag
	
	# Swap Icons of Limited Features in LITE Mode
	rm ~/RetroPie/retropiemenu/icons/impprevious.png
	cp ~/RetroPie/retropiemenu/icons/impprevious0ff.png ~/RetroPie/retropiemenu/icons/impprevious.png
	
	if [[ $(cat $IMPSettings/music-switch.flag) == "1" ]]; then
		# Stop mpg123loop
		bash "$IMP/stop.sh"> /dev/null 2>&1
		
		# Clear Current Track Contents for LITE MODE - Set Last Position 0000+0000
		echo "" > $IMPPlaylist/current-track
		echo -e '> 0000+0000  00:00.' >> $IMPPlaylist/current-track
	
		# Resume Playback
		bash "$IMP/play.sh" &
		exit 0
	fi
	
	if [[ ! $(cat $IMPSettings/pause.flag) == "0" ]]; then
		# Stop mpg123loop
		bash "$IMP/stop.sh"> /dev/null 2>&1
	fi
	
	# Clear Current Track Contents for LITE MODE - Set Last Position 0000+0000
	echo "" > $IMPPlaylist/current-track
	echo -e '> 0000+0000  00:00.' >> $IMPPlaylist/current-track
fi

tput reset
exit 0
