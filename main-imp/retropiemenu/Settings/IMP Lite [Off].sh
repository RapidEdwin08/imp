#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

if [[ $(cat $IMPSettings/lite.flag) == "1" ]]; then
	# Turning LITE MODE Off
	echo "0" > $IMPSettings/lite.flag
	
	# Swap Icons of Limited Features in LITE Mode
	rm ~/RetroPie/retropiemenu/icons/impprevious.png
	cp ~/RetroPie/retropiemenu/icons/impprevious0n.png ~/RetroPie/retropiemenu/icons/impprevious.png
	
	if [[ $(cat $IMPSettings/music-switch.flag) == "1" ]]; then
		# Stop mpg123loop
		bash "$IMP/stop.sh"> /dev/null 2>&1
	
		# Resume Playback
		bash "$IMP/play.sh" &
		exit 0
	fi
	
	if [[ ! $(cat $IMPSettings/pause.flag) == "0" ]]; then
		# Stop mpg123loop
		bash "$IMP/stop.sh"> /dev/null 2>&1
	fi
fi

tput reset
exit 0
