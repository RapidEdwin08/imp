#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

# Start 0mxmon
if [ $(cat $IMPSettings/0mxmon.flag) == "1" ]; then
	rm /dev/shm/0mxMonLoop.Active > /dev/null 2>&1
	# kill instances of 0mxmon script
	PIDplayloop=$(ps -eaf | grep "0mxmon.sh" | awk '{print $2}')
	kill $PIDplayloop > /dev/null 2>&1
	rm /dev/shm/0mxwaitstart.sh > /dev/null 2>&1
	bash "$IMP/0mxmon.sh" &
fi

# Lower Volume
lowerVOLUME=$(cat $IMPSettings/lower-idle.volume)
if [ $(cat $IMPSettings/lower-idle.flag) == "1" ] || [ $(cat $IMPSettings/music-over-games.flag) == "2" ]; then
	# If Screensaver or Lower Over Game
	if [ "$1" == "idle" ] && [ $(cat $IMPSettings/lower-idle.flag) == "1" ]; then
		if pgrep mpg123 > /dev/null 2>&1; then
			bash "$IMP/stop.sh" continue > /dev/null 2>&1
			rm /dev/shm/lower-idle.volume > /dev/null 2>&1 # Remove 0ne-Time-Use 0mxmon L00P Lower Volume Setting - Also Added to [mpg123loop.sh]
			bash "$IMP/play.sh" & # Resume Playback
		fi
		if [ ! $(cat $IMPSettings/pause.flag) == "2" ]; then exit 0; fi
	fi
	if [ "$1" == "" ] && [ $(cat $IMPSettings/music-over-games.flag) == "2" ]; then
		if pgrep mpg123 > /dev/null 2>&1; then
			bash "$IMP/stop.sh" continue > /dev/null 2>&1
			rm /dev/shm/lower-idle.volume > /dev/null 2>&1 # Remove 0ne-Time-Use 0mxmon L00P Lower Volume Setting - Also Added to [mpg123loop.sh]
			bash "$IMP/play.sh" & # Resume Playback
		fi
		if [ ! $(cat $IMPSettings/pause.flag) == "2" ]; then exit 0; fi
	fi
fi

if [ "$1" == "idle" ] || [ "$1" == "sleep" ]; then
	# [IDLE] Do Nothing If [pause.flag] NOT called by [run-onstart] or [idle-onstart] Script[2]
	if [ ! $(cat $IMPSettings/pause.flag) == "2" ]; then
		exit 0
	fi
fi
if [ "$1" == "" ]; then
	# [RUNCMD] Do Nothing If [pause.flag] NOT called by [run-onstart] Script[2] or [music-over-games.flag] ON
	if [ ! $(cat $IMPSettings/pause.flag) == "2" ] || [ $(cat $IMPSettings/music-over-games.flag) == "1" ]; then
		exit 0
	fi
fi

# Delay at Game End
if [ "$1" == "" ]; then
	sleep $(cat $IMPSettings/delay-playback.flag)
fi

# Set [pause.flag] OFF - Set [music-switch.flag] ON
echo "0" > $IMPSettings/pause.flag
echo "1" > $IMPSettings/music-switch.flag

# Fade setting check determines action
if [[ $(cat $IMPSettings/fade-out.flag) == "0" ]]; then
	bash "$IMP/play.sh" > /dev/null 2>&1 #pkill -CONT mpg123
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

# If the last value is anything other than blank then the Volume Fade In [run-onstart.sh] could still be Script is Still Running
if [[ ! "$(cat $IMPSettings/volume.last 2>/dev/null)" == '' ]]; then
	# kill instances of run-onstart.sh scripts - prevents tug of war with Volume Fade In/Out
	PIDonEND=$(ps -eaf | grep "run-onstart.sh" | awk '{print $2}')
	kill $PIDonEND > /dev/null 2>&1
	
	currentVOL=$(cat $IMPSettings/volume.last)
fi

# Set Volume to 0% to start fade in - then continue player
$amixerCMD --quiet set $audioDEVICEcurrent 0%

# set Dynamic Volume to check while increasing volume - '/dB/
dynamicVOL=$(awk -F"[][]" '/dB/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
if [[ $dynamicVOL == '' ]]; then
	# set Dynamic Volume to check while increasing volume - '/Left:/
	dynamicVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
fi

# Result Expected if ERROR - amixer: Unable to find simple control 
if [[ $dynamicVOL == '' ]]; then
		echo "Unable to Identify Obtain Current VOLUME. Skipping Fade ..."
		bash "$IMP/play.sh" > /dev/null 2>&1 #pkill -CONT mpg123
		exit 0
fi

# Continue player
bash "$IMP/play.sh" > /dev/null 2>&1 #pkill -CONT mpg123

# Increase Volume until Dynamic Volume reaches previously obtained Current Volume
while [ $dynamicVOL -lt $currentVOL ]; do
	# Increase Alsa Volume
	# $amixerCMD -q -c 0 sset "$audioDEVICEcurrent" 1db+ unmet no cap # NOT Working with Headphone
	((dynamicVOL=dynamicVOL+1))
	$amixerCMD --quiet set "$audioDEVICEcurrent" "$dynamicVOL"%
	# set Dynamic Volume to check while increasing volume - '/dB/
	dynamicVOL=$(awk -F"[][]" '/dB/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
	if [[ $dynamicVOL == '' ]]; then
		# set Dynamic Volume to check while increasing volume - '/Left:/
		dynamicVOL=$(awk -F"[][]" '/Left:/ { print $2 }' <($amixerCMD sget $audioDEVICEcurrent 2>/dev/null) | cut -d '%' -f 1 )
	fi
	sleep 0.01
done

# set Volume back to Original setting after Fade
$amixerCMD --quiet set $audioDEVICEcurrent $currentVOL%

# Set [volume.last] BLANK
cat /dev/null > $IMPSettings/volume.last
exit 0
