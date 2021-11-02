#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist

# Settings Flags
echo "0" > $IMPSettings/music-switch.flag
echo "0" > $IMPSettings/pause.flag

# [$IMP/mpg123loop.sh] runs with -continue -k to Continue from Last Frame Position pulled from [$IMPPlaylist/current-track]
# If [$IMP/stop.sh] called with ANY Argument - Continue track from Last Position by NOT Setting Last Position 0000+0000 
# If [$IMP/stop.sh] called with NO Argument - Start from the beginning by Setting Last Position 0000+0000 > [$IMPPlaylist/current-track]

if [[ $1 == '' ]] && [[ $(cat $IMPSettings/lite.flag) == "0" ]]; then
	pkill -STOP mpg123  > /dev/null 2>&1
	# Start from the beginning by Setting Last Position 0000+0000
	echo "" >> $IMPPlaylist/current-track
	echo -e '> 0000+0000  00:00.' >> $IMPPlaylist/current-track
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
