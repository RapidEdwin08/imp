#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

# Do Nothing If [music-switch.flag] OFF or [music-over-games.flag] ON
if [ $(cat /opt/retropie/configs/imp/settings/music-switch.flag) == "0" ] || [ $(cat /opt/retropie/configs/imp/settings/music-over-games.flag) == "1" ]; then
	exit 0
fi

# Set [pause.flag] ON called by Script [2] - Set [music-switch.flag] OFF
echo "2" > $IMPSettings/pause.flag
echo "0" > $IMPSettings/music-switch.flag

# Fade setting determines action
if [[ $(cat $IMPSettings/fade-out.flag) == "0" ]]; then
	pkill -STOP mpg123
	exit 0
fi

# Identify current Alsa Device by Process of Elimination - Expecting HDMI - PCM - Master - Headphone - Speaker - Digital - Analogue
if [[ $(amixer | grep "Simple mixer control" ) == *"HDMI"* ]]; then alsaCURRENT="HDMI"; fi
if [[ $(amixer | grep "Simple mixer control" ) == *"PCM"* ]]; then alsaCURRENT="PCM"; fi
if [[ $(amixer | grep "Simple mixer control" ) == *"Master"* ]]; then alsaCURRENT="Master"; fi
if [[ $(amixer | grep "Simple mixer control" ) == *"Headphone"* ]]; then alsaCURRENT="Headphone"; fi
if [[ $(amixer | grep "Simple mixer control" ) == *"Speaker"* ]]; then alsaCURRENT="Speaker"; fi
if [[ $(amixer | grep "Simple mixer control" ) == *"Digital"* ]]; then alsaCURRENT="Digital"; fi
if [[ $(amixer | grep "Simple mixer control" ) == *"Analogue"* ]]; then alsaCURRENT="Analogue"; fi

# Determine how to Parse amixer output for volume - /dB/ or /Left:/ depending on Version of the OS (2021-11)
volumePARSE='/dB/ { print $2 }'
if [[ $(awk -F"[][]" "$volumePARSE" <(amixer sget $alsaCURRENT) ) == '' ]]; then volumePARSE='/Left:/ { print $2 }'; fi

# Obtain current Volume Setting before fade
currentVOL=$(awk -F"[][]" "$volumePARSE" <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )

# Current Volume Test - Result Expected if ERROR - amixer: Unable to find simple control 
if [[ $currentVOL == *"Unable to find simple control"* || $currentVOL == '' ]]; then
		echo "Unable to Identify Obtain Current VOLUME. Skipping Fade Out..."
		pkill -STOP mpg123 > /dev/null 2>&1
		exit 0
fi

# Volume Set Test - Result Expected if ERROR - amixer: Unable to find simple control 
volSETtest=$(amixer --quiet set "$alsaCURRENT" "$currentVOL"%)
if [[ $volSETtest == *"Unable to find simple control"* ]]; then
		echo "Unable to ADJUST Volume. Skipping Fade ..."
		pkill -STOP mpg123 > /dev/null 2>&1
		exit 0
fi

# If [volume.last] is anything other than BLANK the Volume Fade In [run-onend.sh] Script COULD STILL BE RUNNING
if [[ ! "$(cat $IMPSettings/volume.last)" == '' ]]; then
	# kill instances of [run-onend.sh] scripts - prevents Tug of War with Volume Fade In/Out
	PIDonEND=$(ps -eaf | grep "run-onend.sh" | awk '{print $2}')
	kill $PIDonEND > /dev/null 2>&1
	
	currentVOL=$(cat $IMPSettings/volume.last)
	amixer --quiet set "$alsaCURRENT" "$currentVOL"%
fi

# Set Initial Dynamic Volume to check while decreasing volume
dynamicVOL=$(awk -F"[][]" "$volumePARSE" <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )

# Increase Volume until Dynamic Volume reaches previously obtained Current Volume
while [ $dynamicVOL -gt 0 ]; do
	# Decrease Alsa Volume
	((dynamicVOL=dynamicVOL-1))
	amixer --quiet set "$alsaCURRENT" "$dynamicVOL"%
	# set Dynamic Volume to check while decreasing volume - '/dB/
	dynamicVOL=$(awk -F"[][]" "$volumePARSE" <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
	# sleep 0.02 # Adds longer wait when loading ROMs
done

# Stop/Pause player after Volume 0 - allow time for mpg123 to stop
pkill -STOP mpg123
sleep 0.1

# set Volume back to Original setting after Fade
amixer --quiet set $alsaCURRENT $currentVOL%

# Set [volume.last]
echo $currentVOL > $IMPSettings/volume.last

exit 0
