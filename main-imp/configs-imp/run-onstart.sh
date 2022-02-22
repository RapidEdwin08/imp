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

# Parse amixer output for volume - /dB/ or /Left:/ depending on Version of the OS
# awk -F"[][]" '/dB/ { print $2 }' <(amixer sget Master)
# awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master)

# Obtain current Volume Setting before fade out - '/dB/
currentVOL=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )

# Obtain current Volume Setting before fade out - '/Left:/
if [[ $currentVOL == '' ]]; then
	currentVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
fi

# Result Expected if ERROR - amixer: Unable to find simple control 
if [[ $currentVOL == *"Unable to find simple control"* || $currentVOL == '' ]]; then
		echo "Unable to Identify Obtain Current VOLUME. Skipping Fade Out..."
		pkill -STOP mpg123
		exit 0
fi

# If the last value is anything other than blank then the Volume Fade In [run-onend.sh] Script is Still Running
if [[ ! "$(cat $IMPSettings/volume.last)" == '' ]]; then
	# kill instances of run-onend.sh scripts - prevents tug of war with Volume Fade In/Out
	PIDonEND=$(ps -eaf | grep "run-onend.sh" | awk '{print $2}')
	kill $PIDonEND > /dev/null 2>&1
	
	currentVOL=$(cat $IMPSettings/volume.last)
	amixer --quiet set "$alsaCURRENT" "$currentVOL"%
fi

# set Dynamic Volume to check while decreasing volume - '/dB/
dynamicVOL=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
if [[ $dynamicVOL == '' ]]; then
	# set Dynamic Volume to check while decreasing volume - '/Left:/
	dynamicVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
fi

# Result Expected if ERROR - amixer: Unable to find simple control 
if [[ $dynamicVOL == *"Unable to find simple control"* || $dynamicVOL == '' ]]; then
		echo "Unable to Identify Obtain Current VOLUME. Skipping Fade ..."
		pkill -STOP mpg123
		exit 0
fi

# Increase Volume until Dynamic Volume reaches previously obtained Current Volume
while [ $dynamicVOL -gt 0 ]; do
	# Decrease Alsa Volume
	# amixer -q -c 0 sset "$alsaCURRENT" 1db- unmet no cap # NOT Working with Headphone
	((dynamicVOL=dynamicVOL-1))
	amixer --quiet set "$alsaCURRENT" "$dynamicVOL"%
	# set Dynamic Volume to check while decreasing volume - '/dB/
	dynamicVOL=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
	if [[ $dynamicVOL == '' ]]; then
		# set Dynamic Volume to check while decreasing volume - '/Left:/
		dynamicVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
	fi
	sleep 0.02
done

# Stop/Pause player after Volume 0 - allow time for mpg123 to stop
pkill -STOP mpg123
sleep 0.2

# set Volume back to Original setting after Fade
amixer --quiet set $alsaCURRENT $currentVOL%

# Set [volume.last]
echo $currentVOL > $IMPSettings/volume.last

exit 0
