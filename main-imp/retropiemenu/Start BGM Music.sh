#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# musicDIR=$(readlink ~/RetroPie/retropiemenu/imp/music) # ES does not play well with Symbolic Links in [retropiemenu]
musicDIR=~/RetroPie/retropiemenu/imp/music
musicROMS=~/RetroPie/roms/music
BGMdir="$musicDIR/bgm"
BGMa="$musicDIR/bgm/A-SIDE"
BGMb="$musicDIR/bgm/B-SIDE"

# Create Music Directories if not found
if [ ! -d "$musicDIR" ]; then mkdir "$musicDIR"; fi
if [ ! -d "$musicROMS" ]; then ln -s "$musicDIR" "$musicROMS"; fi
if [ ! -d "$BGMdir" ]; then mkdir "$BGMdir"; fi
if [ ! -d "$BGMa" ]; then mkdir "$BGMa"; fi
if [ ! -d "$BGMb" ]; then mkdir "$BGMb"; fi

# Stop mpg123loop with continue parameter
bash "$IMP/stop.sh" continue > /dev/null 2>&1

# Clear playlists
cat /dev/null > $IMPPlaylist/init
cat /dev/null > $IMPPlaylist/abc
cat /dev/null > $IMPPlaylist/shuffle

# Put something in [BGMdir] If No MP3s found
mp3BGMa=$(find $BGMa -iname *.mp3 )
mp3BGMb=$(find $BGMb -iname *.mp3 )
if [[ "$mp3BGMa" == '' ]]; then cp ~/RetroPie/retropiemenu/icons/impstartbgmm0a.png "$musicDIR/bgm/A-SIDE/e1m2.mp3" > /dev/null 2>&1; fi
if [[ "$mp3BGMb" == '' ]]; then cp ~/RetroPie/retropiemenu/icons/impstartbgmm0b.png "$musicDIR/bgm/B-SIDE/ddtblu.mp3" > /dev/null 2>&1; fi

# Add all MP3s from BGM A-SIDE directory to Playlist Non-Recursive
find "$BGMa" -maxdepth 1 -type f -name "*.mp3" > $IMPPlaylist/abc

# Add all MP3s from BGM B-SIDE directory to Playlist Non-Recursive
find "$BGMb" -maxdepth 1 -type f -name "*.mp3" > $IMPPlaylist/shuffle

# Sort INIT playlist with desired 0rder
cat $IMPPlaylist/abc | sort -n > $IMPPlaylist/init
cat $IMPPlaylist/shuffle | sort -n >> $IMPPlaylist/init

# Rebuild ABC and Shuffle Playlists with updated 0rder
cat $IMPPlaylist/init > $IMPPlaylist/abc
cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle
	
# Escape the /\slashes/\ in the Paths
ESCmusicROMS=${musicROMS//\//\\/}
ESCmusicDIR=${musicDIR//\//\\/}

# Replace rpMenu/music Path with roms/Music Path in Playlist files
sed -i s+$ESCmusicDIR+$ESCmusicROMS+ $IMPPlaylist/abc
sed -i s+$ESCmusicDIR+$ESCmusicROMS+ $IMPPlaylist/shuffle
sed -i s+$ESCmusicDIR+$ESCmusicROMS+ $IMPPlaylist/init

# Start the Music Player Loop Script
bash "$IMP/play.sh"
exit 0
