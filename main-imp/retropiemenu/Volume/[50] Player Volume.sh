#!/bin/bash
# mpg123 -f  "32768" # Volume % "100"
# mpg123 -f  "29484" # Volume % "90 "
# mpg123 -f  "26208" # Volume % "80 "
# mpg123 -f  "22932" # Volume % "70 "
# mpg123 -f  "19656" # Volume % "60 "
# mpg123 -f  "16380" # Volume % "50 "
# mpg123 -f  "13104" # Volume % "40 "
# mpg123 -f  "9828" # Volume % "30 "
# mpg123 -f  "6552" # Volume % "20 "
# mpg123 -f  "3276" # Volume % "10 "
# mpg123 -f  "1638" # Volume % "5  "
volumeLEVEL=16380
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

if [[ ! $(cat $IMPSettings/volume.flag) == "$volumeLEVEL" ]]; then
	# Setting Volume
	echo "$volumeLEVEL" > $IMPSettings/volume.flag
	
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
