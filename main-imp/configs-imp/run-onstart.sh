#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

# Stop 0mxmon
if [ $(cat $IMPSettings/0mxmon.flag) == "1" ]; then
	rm /dev/shm/0mxMonLoop.Active > /dev/null 2>&1
	# kill instances of 0mxmon script
	PIDplayloop=$(ps -eaf | grep "0mxmon.sh" | awk '{print $2}')
	kill $PIDplayloop > /dev/null 2>&1
	rm /dev/shm/0mxwaitstart.sh > /dev/null 2>&1
fi

# Lower Volume
lowerVOLUME=$(cat $IMPSettings/lower-idle.volume)
if [ $(cat $IMPSettings/lower-idle.flag) == "1" ] || [ $(cat $IMPSettings/music-over-games.flag) == "2" ]; then
	# If Screensaver or Lower Over Game
	if [ "$1" == "idle" ] && [ $(cat $IMPSettings/lower-idle.flag) == "1" ]; then
		if pgrep mpg123 > /dev/null 2>&1; then
			bash "$IMP/stop.sh" continue > /dev/null 2>&1
			echo "$lowerVOLUME" > /dev/shm/lower-idle.volume
			bash "$IMP/play.sh" & # Resume Playback
		fi
		exit 0
	fi
	if [ "$1" == "" ] && [ $(cat $IMPSettings/music-over-games.flag) == "2" ]; then
		if pgrep mpg123 > /dev/null 2>&1; then
			bash "$IMP/stop.sh" continue > /dev/null 2>&1
			echo "$lowerVOLUME" > /dev/shm/lower-idle.volume
			bash "$IMP/play.sh" & # Resume Playback
		fi
		exit 0
	fi
fi

if [ "$1" == "idle" ] || [ "$1" == "sleep" ]; then
	# [IDLE] Do Nothing If [music-switch.flag] OFF
	if [ $(cat $IMPSettings/music-switch.flag) == "0" ]; then
		exit 0
	fi
fi
if [ "$1" == "" ]; then
	# [RUNCMD] Do Nothing If [music-switch.flag] OFF or [music-over-games.flag] ON
	if [ $(cat $IMPSettings/music-switch.flag) == "0" ] || [ $(cat $IMPSettings/music-over-games.flag) == "1" ]; then
		exit 0
	fi
fi

# Set [pause.flag] ON called by Script [2] - Set [music-switch.flag] OFF
echo "2" > $IMPSettings/pause.flag
echo "0" > $IMPSettings/music-switch.flag

# Fade setting determines action
if [[ $(cat $IMPSettings/fade-out.flag) == "0" ]]; then
	bash "$IMP/stop.sh" continue > /dev/null 2>&1 #pkill -STOP mpg123
	exit 0
fi

# Identify current Audio Device by Pulling AudioDevice Setting from [es_settings.cfg] - Expecting HDMI - PCM - Master - Headphone - Speaker - Digital - Analogue
audioDEVICEcurrent=$(cat /opt/retropie/configs/all/emulationstation/es_settings.cfg | grep "AudioDevice" | awk -F'=' '{print $3}'| cut -c 2- | rev | cut -c 5- | rev)

# Parse amixer output for volume - /dB/ or /Left:/ depending on Version of the OS
# awk -F"[][]" '/dB/ { print $2 }' <(amixer sget Master)
# awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master)

# System may be using pulseaudio - use variable amixerCMD
amixerCMD=amixer

# Obtain current Volume Setting before fade out - Try BOTH  '/dB/  and   '/Left:/
currentVOL=$(awk -F"[][]" '/dB/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
if [[ $currentVOL == '' ]]; then
	currentVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
fi

# Try pulseaudio IF STILL Result Expected if ERROR - amixer: Unable to find simple control 
if [[ $currentVOL == '' ]]; then
	amixerCMD='amixer -D pulse'
	# Obtain current Volume Setting before fade out - Try BOTH  '/dB/  and   '/Left:/ AGAIN with [amixer -D pulse]
	currentVOL=$(awk -F"[][]" '/dB/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
	if [[ $currentVOL == '' ]]; then
		currentVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
	fi
fi

# Result Expected if ERROR - amixer: Unable to find simple control 
if [[ $currentVOL == '' ]]; then
		echo "Unable to Identify Obtain Current VOLUME. Skipping Fade Out..."
		bash "$IMP/stop.sh" continue > /dev/null 2>&1 #pkill -STOP mpg123
		exit 0
fi

# If the last value is anything other than blank then the Volume Fade In [run-onend.sh] Script is Still Running
if [[ ! "$(cat $IMPSettings/volume.last 2>/dev/null)" == '' ]]; then
	# kill instances of run-onend.sh scripts - prevents tug of war with Volume Fade In/Out
	PIDonEND=$(ps -eaf | grep "run-onend.sh" | awk '{print $2}')
	kill $PIDonEND > /dev/null 2>&1
	
	currentVOL=$(cat $IMPSettings/volume.last)
	$amixerCMD --quiet set "$audioDEVICEcurrent" "$currentVOL"%
fi

# Set [volume.last]
echo $currentVOL > $IMPSettings/volume.last

# set Dynamic Volume to check while decreasing volume - '/dB/
dynamicVOL=$(awk -F"[][]" '/dB/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
if [[ $dynamicVOL == '' ]]; then
	# set Dynamic Volume to check while decreasing volume - '/Left:/
	dynamicVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
fi

# Result Expected if ERROR - amixer: Unable to find simple control 
if [[ $dynamicVOL == '' ]]; then
		echo "Unable to Identify Obtain Current VOLUME. Skipping Fade ..."
		bash "$IMP/stop.sh" continue > /dev/null 2>&1 #pkill -STOP mpg123
		exit 0
fi

# Increase Volume until Dynamic Volume reaches previously obtained Current Volume
while [ $dynamicVOL -gt 0 ]; do
	# Decrease Alsa Volume
	# $amixerCMD -q -c 0 sset "$audioDEVICEcurrent" 1db- unmet no cap # NOT Working with Headphone
	((dynamicVOL=dynamicVOL-1))
	$amixerCMD --quiet set "$audioDEVICEcurrent" "$dynamicVOL"%
	# set Dynamic Volume to check while decreasing volume - '/dB/
	dynamicVOL=$(awk -F"[][]" '/dB/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
	if [[ $dynamicVOL == '' ]]; then
		# set Dynamic Volume to check while decreasing volume - '/Left:/
		dynamicVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
	fi
	sleep 0.015
done

# Stop/Pause player after Volume 0 - allow time for mpg123 to stop
bash "$IMP/stop.sh" continue > /dev/null 2>&1 #pkill -STOP mpg123
sleep 0.2

# set Volume back to Original setting after Fade
$amixerCMD --quiet set $audioDEVICEcurrent $currentVOL%

exit 0
