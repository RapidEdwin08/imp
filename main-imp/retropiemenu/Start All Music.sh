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

# Put something in [musicDIR] If No MP3s found at all
mp3MUSIC=$(find $musicDIR -iname *.mp3 )
if [[ "$mp3MUSIC" == '' ]]; then cp ~/RetroPie/retropiemenu/icons/impstartallm0.png "$musicDIR/CCCool.mp3" > /dev/null 2>&1; fi

# If BGMa flag 1 - Put something in [BGMadir] If No MP3s found
if [ "$(cat $IMPSettings/a-side.flag)" == '1' ]; then
	mp3BGMa=$(find $BGMa -iname *.mp3 )
	if [[ "$mp3BGMa" == '' ]]; then cp ~/RetroPie/retropiemenu/icons/impstartbgmm0a.png "$musicDIR/bgm/A-SIDE/e1m2.mp3" > /dev/null 2>&1; fi
fi

# If BGMb flag 1 - Put something in [BGMbdir] If No MP3s found
if [ "$(cat $IMPSettings/b-side.flag)" == '1' ]; then
	mp3BGMb=$(find $BGMb -iname *.mp3 )
	if [[ "$mp3BGMb" == '' ]]; then cp ~/RetroPie/retropiemenu/icons/impstartbgmm0b.png "$musicDIR/bgm/B-SIDE/ddtblu.mp3" > /dev/null 2>&1; fi
fi

# Add all MP3s from musicROMS directory to Playlist Non-Recursive
find "$musicDIR" -maxdepth 1 -type f -name "*.mp3" > $IMPPlaylist/abc

# Add all MP3s from musicROMS SUB-directories to Playlist Recursive
find "$musicDIR"/*/ -iname "*.mp3" > $IMPPlaylist/shuffle

# Remove BGM A-SIDE/B-SIDE MP3s from musicROMS SUB-directories According to BGM Settings
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
