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

# Called after read line in mpg123loop
# Sets Last Position 0000 to have next track in Playlist start from the beginning
# Checks for common mpg123 Errors to Kill Infinite Loop in Event of Errors

# Last Position 0000 to have next track in Playlist start from the beginning
echo "" >> $currentTRACK
echo -e '> 0000+0000' >> $currentTRACK
# sleep 2

# Check for common mpg123 Errors
# [error: Cannot open] [error: Unable to establish connection] [error: reading the rest of] [error: buffer reading]
errorCOMMON=$(tail -n 9 $currentTRACK | grep -q 'error:' ; echo $?)
if [ "$errorCOMMON" == '0' ]; then bash $IMP/stop.sh && exit 0; fi

# You made some mistake in program usage... let me briefly remind you:
errorSYNTAX=$(head -n 1 $currentTRACK | grep -q 'You made some mistake in program usage... let me briefly remind you:' ; echo $?)
if [ "$errorSYNTAX" == '0' ]; then bash $IMP/stop.sh && exit 0; fi

# === Cannot specify output file without previously specifying a driver.
errorDRIVER=$(tail -n 9 $currentTRACK | grep -q 'Cannot specify output file without previously specifying a driver' ; echo $?)
if [ "$errorDRIVER" == '0' ]; then bash $IMP/stop.sh && exit 0; fi

tput reset
exit 0
