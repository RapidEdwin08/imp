#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

if [[ $(cat $IMPSettings/infinite.flag) == "0" ]]; then
	# Turning INFINITE REPEAT On
	echo "1" > $IMPSettings/infinite.flag
	
	if [[ $(cat $IMPSettings/music-switch.flag) == "1" ]]; then
		# Stop mpg123loop WITH continue parameter
		bash "$IMP/stop.sh" continue > /dev/null 2>&1
	
		# Resume Playback
		bash "$IMP/play.sh" &
		exit 0
	fi
	
	if [[ ! $(cat $IMPSettings/pause.flag) == "0" ]]; then
		# Stop mpg123loop WITH continue parameter
		bash "$IMP/stop.sh" continue > /dev/null 2>&1
		
		# Set [pause.flag] 
		echo "1" > $IMPSettings/pause.flag
	fi
fi

tput reset
exit 0
