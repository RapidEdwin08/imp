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

# Start HTTP Server if flag 1 - Used at Startup
if [ $(cat $IMPSettings/http-server.flag) == "1" ]; then sleep 5 && bash "$IMP/httpon.sh"; fi &

# Exit if music startup flag 0
if [ $(cat $IMPSettings/music-startup.flag) == "0" ]; then exit 0; fi

# Delay at Startup
sleep $(cat $IMPSettings/delay-startup.flag)

# Stop any 0ther [Unknown] mpg123 Scripts
pkill -STOP mpg123 > /dev/null 2>&1
pkill -KILL mpg123 > /dev/null 2>&1

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

# If any BGM flags 1 - Clear init playlist
if [[ $(cat $IMPSettings/a-side.flag) == "1" || $(cat $IMPSettings/b-side.flag) == "1" ]]; then
	cat /dev/null > $IMPPlaylist/init
fi

# Overwrite init playlist if BGM A-SIDE flag 1
if [ $(cat $IMPSettings/a-side.flag) == "1" ]; then
	# Output A-SIDE to init playlist
	find $BGMa -iname "*.mp3" > $IMPPlaylist/init
	cat $IMPPlaylist/init | sort -n > $IMPPlaylist/abc
	cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle
fi

# Append init playlist if BGM B-SIDE flag 1
if [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	# Append B-SIDE to init playlist
	find $BGMb -iname "*.mp3" >> $IMPPlaylist/init
	cat $IMPPlaylist/init | sort -n > $IMPPlaylist/abc
	cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle
fi

# Start the Music Play Script
bash "$IMP/play.sh" &
exit 0
