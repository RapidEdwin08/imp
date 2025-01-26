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

# Add all MP3s from musicDIR directory to Playlist Non-Recursive
find "$musicDIR" -maxdepth 1 -type f -iname "*.mp3" > /dev/shm/abc

# Add all MP3s from musicDIR SUB-directories to Playlist Recursive
find "$musicDIR"/*/ -iname "*.mp3" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' > /dev/shm/shuffle

# Remove BGM A-SIDE/B-SIDE MP3s from musicDIR SUB-directories According to BGM Settings
if [ "$(cat $IMPSettings/a-side.flag)" == '0' ]; then
	cat "/dev/shm/shuffle" | grep -Fv 'imp/music/bgm/A-SIDE/' > /dev/shm/init
	cat "/dev/shm/init" > /dev/shm/shuffle
fi
if [ "$(cat $IMPSettings/b-side.flag)" == '0' ]; then
	cat "/dev/shm/shuffle" | grep -Fv 'imp/music/bgm/B-SIDE/' > /dev/shm/init
	cat "/dev/shm/init" > /dev/shm/shuffle
fi

# Sort INIT playlist with desired 0rder
cat /dev/shm/abc | sort -n > $IMPPlaylist/init
cat /dev/shm/shuffle | sort -n >> $IMPPlaylist/init

# Rebuild ABC and Shuffle Playlists with updated 0rder
cat $IMPPlaylist/init > $IMPPlaylist/abc
cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle

# Clean up
rm /dev/shm/abc 2>/dev/null; rm /dev/shm/shuffle 2>/dev/null; rm /dev/shm/init 2>/dev/null

# Start the Music Player Loop Script
bash "$IMP/play.sh"
exit 0
