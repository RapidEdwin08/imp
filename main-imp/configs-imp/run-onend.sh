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

# Determine how to Parse amixer output for volume - /dB/ or /Left:/ depending on Version of the OS (2021-11)
volumePARSE='/dB/ { print $2 }'
if [[ $(awk -F"[][]" "$volumePARSE" <(amixer sget $alsaCURRENT) ) == '' ]]; then volumePARSE='/Left:/ { print $2 }'; fi

# Obtain current Volume Setting before fade
currentVOL=$(awk -F"[][]" "$volumePARSE" <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )

# Current Volume Test - Result Expected if ERROR - amixer: Unable to find simple control 
if [[ $currentVOL == *"Unable to find simple control"* || $currentVOL == '' ]]; then
		echo "Unable to Identify Obtain Current VOLUME. Skipping Fade ..."
		pkill -CONT mpg123 > /dev/null 2>&1
		exit 0
fi

# Volume Set Test - Result Expected if ERROR - amixer: Unable to find simple control 
volSETtest=$(amixer --quiet set "$alsaCURRENT" "$currentVOL"%)
if [[ $volSETtest == *"Unable to find simple control"* ]]; then
		echo "Unable to ADJUST Volume. Skipping Fade ..."
		pkill -CONT mpg123 > /dev/null 2>&1
		exit 0
fi

# Set Volume to 0% to start fade in - then continue player
amixer --quiet set $alsaCURRENT 0%

# Set Initial Dynamic Volume to check while increasing volume - '/dB/
dynamicVOL=$(awk -F"[][]" "$volumePARSE" <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )

# Continue player
pkill -CONT mpg123 > /dev/null 2>&1

# Increase Volume until Dynamic Volume reaches previously obtained Current Volume
while [ $dynamicVOL -lt $currentVOL ]; do
	# Increase Alsa Volume
	((dynamicVOL=dynamicVOL+1))
	amixer --quiet set "$alsaCURRENT" "$dynamicVOL"%
	# set Dynamic Volume to check while increasing volume - '/dB/
	dynamicVOL=$(awk -F"[][]" "$volumePARSE" <(amixer sget $alsaCURRENT) | cut -d '%' -f 1 )
	sleep 0.005
done

# set Volume back to Original setting after Fade
amixer --quiet set $alsaCURRENT $currentVOL%

# Set [volume.last] BLANK
cat /dev/null > $IMPSettings/volume.last
exit 0
