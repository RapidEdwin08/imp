#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# FULL MODE Write to Disk - LITE MODE Write to tmpfs - Recall Last Track/Position Lost on REBOOT using LITE MODE
currentTRACK=$IMPPlaylist/current-track
if [ $(cat $IMPSettings/lite.flag) == "1" ]; then currentTRACK=/dev/shm/current-track; fi

# Called after read line in mpg123loop (Does NOT apply to LITE MODE)
# Checks for common mpg123 Errors to Kill Loop in Event of Errors
# Sets Last Position 0000 to have next track in Playlist start from the beginning

# Last Position 0000 to have next track in Playlist start from the beginning
echo "" >> $currentTRACK
echo -e '> 0000+0000' >> $currentTRACK
# sleep 2

# Check for cannot open file error
errorOPEN=$(tail -n 5 $currentTRACK | grep -q 'error: Cannot open' ; echo $?)
if [ "$errorOPEN" == '0' ]; then bash $IMP/stop.sh && exit 0; fi

# Check for connection error
errorCONN=$(tail -n 5 $currentTRACK | grep -q 'error: Unable to establish connection' ; echo $?)
if [ "$errorCONN" == '0' ]; then bash $IMP/stop.sh && exit 0; fi

# Check for error: reading the rest of 4096
# [src/libmpg123/readers.c:186] error: reading the rest of 4096
errorREAD=$(tail -n 5 $currentTRACK | grep -q 'error: reading the rest of' ; echo $?)
if [ "$errorREAD" == '0' ]; then bash $IMP/stop.sh && exit 0; fi

# Check for error: buffer reading
# [src/libmpg123/readers.c:844] error: buffer reading
errorBUFFER=$(tail -n 5 $currentTRACK | grep -q 'error: buffer reading' ; echo $?)
if [ "$errorBUFFER" == '0' ]; then bash $IMP/stop.sh && exit 0; fi

# === Cannot specify output file without previously specifying a driver.
errorDRIVER=$(tail -n 5 $currentTRACK | grep -q 'Cannot specify output file without previously specifying a driver' ; echo $?)
if [ "$errorDRIVER" == '0' ]; then bash $IMP/stop.sh && exit 0; fi

# You made some mistake in program usage... let me briefly remind you:
errorSYNTAX=$(tail -n 5 $currentTRACK | grep -q 'You made some mistake in program usage... let me briefly remind you:' ; echo $?)
if [ "$errorSYNTAX" == '0' ]; then bash $IMP/stop.sh && exit 0; fi

# Check for bad file by way of Finished Decoding after 0:01 sec
# errorOO1=$(tail -n 5 $currentTRACK | grep -q '[0:01]' ; echo $?)
# if [ "$errorOO1" == '0' ]; then bash $IMP/stop.sh && exit 0; fi

tput reset
exit 0
