#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

# Do Nothing If [pause.flag] NOT called by [run-onstart] Script[2] or [music-over-games.flag] ON
if [ ! $(cat /opt/retropie/configs/imp/settings/pause.flag) == "2" ] || [ $(cat /opt/retropie/configs/imp/settings/music-over-games.flag) == "1" ]; then
	exit 0
fi

# Delay at Game End
sleep $(cat $IMPSettings/delay-playback.flag)

# Set [pause.flag] OFF - Set [music-switch.flag] ON
echo "0" > $IMPSettings/pause.flag
echo "1" > $IMPSettings/music-switch.flag

# Fade setting check determines action
if [[ $(cat $IMPSettings/fade-out.flag) == "0" ]]; then
	pkill -CONT mpg123
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
		echo "Unable to Identify Obtain Current VOLUME. Skipping Fade ..."
		pkill -CONT mpg123
		exit 0
fi

# Set Volume to 0% to start fade in - then continue player
amixer --quiet set $alsaCURRENT 0%

# set Dynamic Volume to check while increasing volume - '/dB/
dynamicVOL=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
if [[ $dynamicVOL == '' ]]; then
	# set Dynamic Volume to check while increasing volume - '/Left:/
	dynamicVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
fi

# Result Expected if ERROR - amixer: Unable to find simple control 
if [[ $dynamicVOL == *"Unable to find simple control"* || $dynamicVOL == '' ]]; then
		echo "Unable to Identify Obtain Current VOLUME. Skipping Fade ..."
		pkill -CONT mpg123
		exit 0
fi

# Continue player
pkill -CONT mpg123

# Increase Volume until Dynamic Volume reaches previously obtained Current Volume
while [ $dynamicVOL -lt $currentVOL ]; do
	# Increase Alsa Volume
	# amixer -q -c 0 sset "$alsaCURRENT" 1db+ unmet no cap # NOT Working with Headphone
	((dynamicVOL=dynamicVOL+1))
	amixer --quiet set "$alsaCURRENT" "$dynamicVOL"%
	# set Dynamic Volume to check while increasing volume - '/dB/
	dynamicVOL=$(awk -F"[][]" '/dB/ { print $2 }' <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
	if [[ $dynamicVOL == '' ]]; then
		# set Dynamic Volume to check while increasing volume - '/Left:/
		dynamicVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
	fi
	sleep 0.02
done

# set Volume back to Original setting after Fade
amixer --quiet set $alsaCURRENT $currentVOL%

# Set [volume.last] BLANK
cat /dev/null > $IMPSettings/volume.last
exit 0
