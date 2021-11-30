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

# Check for [IMP] Files/Folders Linked to [retropiemenu] [gamelist.xml]
# Create Files/Folders If Needed to Prevent ERROR [Assertion `mType == FLODER' failed]
bash "$IMP/rpmenucheck.sh" > /dev/null 2>&1

# SomaFM Seasonal Stations - Check Current Date and Swap Icons accordingly
if [ -f "$IMP/somafm-specials.sh" ]; then bash $IMP/somafm-specials.sh; fi

# Start HTTP Server if flag 1 - Used at Startup
if [ $(cat $IMPSettings/http-server.flag) == "1" ]; then sleep 5 && bash "$IMP/httpon.sh"; fi &

# Exit if music startup flag 0
if [ $(cat $IMPSettings/music-startup.flag) == "0" ]; then exit 0; fi

# Delay at Startup
sleep $(cat $IMPSettings/delay-startup.flag)

# Stop any 0ther [Unknown] mpg123 Scripts
pkill -STOP mpg123 > /dev/null 2>&1
pkill -KILL mpg123 > /dev/null 2>&1

# Disable Livewire if Not already
if [ ! -f ~/.DisableMusic ]; then touch ~/.DisableMusic; fi

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
