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

# Start the Music Player Loop Script
bash "$IMP/play.sh"
exit 0
