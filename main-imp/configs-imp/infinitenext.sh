#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# musicDIR=$(readlink ~/RetroPie/retropiemenu/imp/music) # ES does not play well with Symbolic Links in [retropiemenu]
musicDIR=~/RetroPie/retropiemenu/imp/music
BGMdir="$musicDIR/bgm"
BGMa="$musicDIR/bgm/A-SIDE"
BGMb="$musicDIR/bgm/B-SIDE"

# Stop mpg123loop with continue parameter
bash "$IMP/stop.sh" continue > /dev/null 2>&1

# Clear playlists
cat /dev/null > $IMPPlaylist/init
cat /dev/null > $IMPPlaylist/abc
cat /dev/null > $IMPPlaylist/shuffle

# Add all MP3s from musicDIR directory to Playlist Non-Recursive
find "$musicDIR" -maxdepth 1 -type f -iname "*.mp3" > $IMPPlaylist/abc

# Add all MP3s from musicDIR SUB-directories to Playlist Recursive
find "$musicDIR"/*/ -iname "*.mp3" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' > $IMPPlaylist/shuffle

# Remove BGM A-SIDE/B-SIDE MP3s from musicDIR SUB-directories According to BGM Settings
if [ "$(cat $IMPSettings/a-side.flag)" == '0' ]; then
	cat "$IMPPlaylist/shuffle" | grep -Fv 'imp/music/bgm/A-SIDE/' > $IMPPlaylist/init
	cat "$IMPPlaylist/init" > $IMPPlaylist/shuffle
fi
if [ "$(cat $IMPSettings/b-side.flag)" == '0' ]; then
	cat "$IMPPlaylist/shuffle" | grep -Fv 'imp/music/bgm/B-SIDE/' > $IMPPlaylist/init
	cat "$IMPPlaylist/init" > $IMPPlaylist/shuffle
fi

# Sort INIT playlist with desired 0rder
cat $IMPPlaylist/abc | sort -n > $IMPPlaylist/init
cat $IMPPlaylist/shuffle | sort -n >> $IMPPlaylist/init

# Rebuild ABC and Shuffle Playlists with updated 0rder
cat $IMPPlaylist/init > $IMPPlaylist/abc
cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle

###################
# FULL MODE Write to Disk - LITE MODE Write to tmpfs - Recall Last Track/Position Lost on REBOOT using LITE MODE
if [ $(cat $IMPSettings/lite.flag) == "0" ]; then
	currentTRACK=$IMPPlaylist/current-track
else
	currentTRACK=/dev/shm/current-track
fi

# Parse Current Track file to obtain Last track played - Cut off the last x4 characters
# Expected Result MP3: Playing MPEG stream 1 of 1: Song.mp3 ...
# Expected Result Stream: Playing MPEG stream 1 of 1: lush-128-mp3 ...
mp3LAST=$(grep -iE 'Playing MPEG stream' $currentTRACK | cut -b 29-999 | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop')

# Expected Result  Directory: /home/pi/RetroPie/roms/music/
# Expected Result  Directory: http://ice1.somafm.com/
dirBASE=$(grep -iE 'Directory:' $currentTRACK | cut -b 12-999)

# Expected Result mp3: /home/pi/RetroPie/roms/music/Song.mp3
# Expected Result stream http://ice1.somafm.com/lush-128-mp3
mp3BASE=$dirBASE$mp3LAST

# Determine ABC or Shuffle Playlist from Settings Flags
if [ $(cat $IMPSettings/shuffle.flag) == "1" ]; then
	currentPLIST="$IMPPlaylist/shuffle"
else
	currentPLIST="$IMPPlaylist/abc"
fi

# If Last Track bLANK Substitute with first Line in ABC Playlist
if [[ "$mp3BASE" == '' ]]; then mp3BASE=$(head -qn1 $currentPLIST); fi

# Determine # of Lines - Shortens the amount of time it takes to Parse Lines with grep
LINEcount=$(grep -c ".*" $currentPLIST)

# Parse all lines after and before Last Track played
grep -FA $LINEcount "$mp3LAST" $currentPLIST | grep -v "$mp3LAST" | grep -v "$dirBASE" > $IMPPlaylist/init
grep -FB $LINEcount "$mp3LAST" $currentPLIST | grep -v "$mp3LAST" | grep -v "$dirBASE" >> $IMPPlaylist/init

# Parse all lines after and before Last Track played again if nothing
if [[ "$(cat $IMPPlaylist/init)" == '' ]]; then
	grep -FA $LINEcount "$mp3BASE" $currentPLIST | grep -Fv "$mp3BASE" > $IMPPlaylist/init
	grep -FB $LINEcount "$mp3BASE" $currentPLIST | grep -Fv "$mp3BASE" >> $IMPPlaylist/init
fi

###################
nextTRACK=$(head -qn1 $IMPPlaylist/init)

# Run Randomizer if still nothing
if [[ "$nextTRACK" == '' ]]; then bash "$IMP/randomizer.sh" & exit 0; fi

# Start the Music Player Loop Script
bash "$IMP/rom.sh" "$nextTRACK" &
exit 0
