#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# FULL MODE Write to Disk - LITE MODE Write to tmpfs - Recall Last Track/Position Lost on REBOOT using LITE MODE
if [ $(cat $IMPSettings/lite.flag) == "0" ]; then
	currentTRACK=$IMPPlaylist/current-track
else
	currentTRACK=/dev/shm/current-track
fi

# Stop 0mxmon
if [[ $(cat /opt/retropie/configs/imp/settings/0mxmon.flag) == "1" ]] && [[ $1 == '' ]]; then
	rm /dev/shm/0mxMonLoop.Active > /dev/null 2>&1
	rm /dev/shm/0mxwaitstart.sh > /dev/null 2>&1
	# kill instances of 0mxmon script
	PIDplayloop=$(ps -eaf | grep "0mxmon.sh" | awk '{print $2}')
	kill $PIDplayloop > /dev/null 2>&1
fi

# Settings Flags
echo "0" > $IMPSettings/music-switch.flag
# Set [pause.flag] to [0] Unless called by Script [run-onstart/end] scripts [2]
if [ ! $(cat $IMPSettings/pause.flag) == "2" ]; then echo "0" > $IMPSettings/pause.flag; fi

# [$IMP/mpg123loop.sh] runs with -continue -k to Continue from Last Frame Position pulled from [$currentTRACK]
# If [$IMP/stop.sh] called with ANY Argument - Continue track from Last Position by NOT Setting Last Position 0000+0000 
# If [$IMP/stop.sh] called with NO Argument - Start from the beginning by Setting Last Position 0000+0000 > [$currentTRACK]

if [[ $1 == '' ]]; then
	pkill -STOP mpg123  > /dev/null 2>&1
	# Start from the beginning by Setting Last Position 0000+0000
	echo "" >> $currentTRACK
	echo -e '> 0000+0000  00:00.' >> $currentTRACK
fi

# kill instances of mpg123 play scripts
PIDplayloop=$(ps -eaf | grep "mpg123loop.sh" | awk '{print $2}')
kill $PIDplayloop > /dev/null 2>&1

PIDerror=$(ps -eaf | grep "errorcheck.sh" | awk '{print $2}')
kill $PIDerror > /dev/null 2>&1

# kill any instances of mpg123 
pkill -KILL mpg123 > /dev/null 2>&1

# tput reset
exit 0
