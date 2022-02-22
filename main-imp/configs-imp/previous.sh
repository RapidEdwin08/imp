#!/bin/bash

# Identify Current Playlist
#  Identify Current Track in Current Playlist
#    Identify Line Before Current Track in Playlist = [previousTRACK]
#     If NOT found Obtrain Last Line in Playlist = [previousTRACK]
#      Re-sort Both Playlists around [previousTRACK]

IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# FULL MODE Write to Disk - LITE MODE Write to tmpfs - Recall Last Track/Position Lost on REBOOT using LITE MODE
if [ $(cat $IMPSettings/lite.flag) == "0" ]; then
	currentTRACK=$IMPPlaylist/current-track
else
	currentTRACK=/dev/shm/current-track
fi
musicDIR=~/RetroPie/retropiemenu/imp/music
BGMdir="$musicDIR/bgm"

# Full Stop
bash $IMP/stop.sh
sleep 0.1

# Determine ABC or Shuffle Playlist from Settings Flags
if [ $(cat $IMPSettings/shuffle.flag) == "1" ]; then
	currentPLIST="$IMPPlaylist/shuffle"
else
	currentPLIST="$IMPPlaylist/abc"
fi

# Determine # of Lines - Shortens the amount of time it takes to Parse Lines with grep
LINEcount=$(grep -c ".*" $currentPLIST)

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
	
# Obtrain Last Line in Playlist After the Re-sort = [previousTRACK]
# previousTRACKbase=$(cat $currentPLIST | tail -n 1 | sed 's/.*\///')
if [[ "$(head -n 1 $currentPLIST)" == "$mp3BASE" ]]; then
	# Obtrain Last Line in Playlist = [previousTRACK]
	previousTRACK=$(cat $currentPLIST | tail -n 1)
else
	# Obtrain Line Before Current Track in Playlist = [previousTRACK]
	previousTRACK=$(grep -FB 1 "$mp3BASE" $currentPLIST | grep -Fv "$mp3BASE")
fi

# Last track played Identified - Rebuild ABC Playlist with Last Track played First
echo $previousTRACK > $IMPPlaylist/init
# Parse all lines after and before Last Track played
grep -FA $LINEcount "$previousTRACK" $IMPPlaylist/abc | grep -Fv "$previousTRACK" | grep -v 'imp/music/bgm/startup.mp3' >> $IMPPlaylist/init
grep -FB $LINEcount "$previousTRACK" $IMPPlaylist/abc | grep -Fv "$previousTRACK" | grep -v 'imp/music/bgm/startup.mp3' >> $IMPPlaylist/init

# Rebuild ABC Playlist with updated 0rder
cat $IMPPlaylist/init > $IMPPlaylist/abc

# Last track played Identified - Rebuild Shuffle Playlist with Last Track played First
echo $previousTRACK > $IMPPlaylist/init
# Parse all lines after and before Last Track played
grep -FA $LINEcount "$previousTRACK" $IMPPlaylist/shuffle | grep -Fv "$previousTRACK" | grep -v 'imp/music/bgm/startup.mp3' >> $IMPPlaylist/init
grep -FB $LINEcount "$previousTRACK" $IMPPlaylist/shuffle | grep -Fv "$previousTRACK" | grep -v 'imp/music/bgm/startup.mp3' >> $IMPPlaylist/init

# Rebuild Shuffle Playlist with updated 0rder
cat $IMPPlaylist/init > $IMPPlaylist/shuffle

# Start the Music Player Loop Script
tput reset
bash "$IMP/mpg123loop.sh" &
exit 0
