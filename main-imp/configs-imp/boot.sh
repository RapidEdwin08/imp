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

# Exit if music startup flag 0 and startupsong flag 0
if [ $(cat $IMPSettings/music-startup.flag) == "0" ] && [ $(cat $IMPSettings/startupsong.flag) == "0" ]; then exit 0; fi

# Delay at Startup
sleep $(cat $IMPSettings/delay-startup.flag)

# Stop any 0ther [Unknown] mpg123 Scripts
pkill -STOP mpg123 > /dev/null 2>&1
pkill -KILL mpg123 > /dev/null 2>&1

# Disable Livewire if Not already
if [ ! -f ~/.DisableMusic ]; then touch ~/.DisableMusic; fi

# [startupsong.play] - Checked by [mpg123loop.sh] - IF [2] Play [startup.mp3] then EXIT - SKIP Playlist Rebuild
if [ $(cat $IMPSettings/music-startup.flag) == "0" ] && [ $(cat $IMPSettings/startupsong.flag) == "1" ]; then
	echo '2' > $IMPSettings/startupsong.play
	bash "$IMP/play.sh" &
	exit 0
fi

# [startupsong.play] - Checked by [mpg123loop.sh] - IF [1] Play [startup.mp3] then Playlist
if [ $(cat $IMPSettings/startupsong.flag) == "1" ]; then echo '1' > $IMPSettings/startupsong.play; fi

# If Randomizer flag NOT = 0 - Random Playlist
if [ ! $(cat $IMPSettings/randomizer.flag) == "0" ]; then
	bash "$IMP/randomizer.sh" &
	exit 0
fi

# If ANY BGM flags 1 - Create BGM Playlists
if [[ $(cat $IMPSettings/a-side.flag) == "1" || $(cat $IMPSettings/b-side.flag) == "1" ]]; then
	# If BGM A-SIDE flag 1 - Create Playlist
	if [ $(cat $IMPSettings/a-side.flag) == "1" ]; then
		# Output A-SIDE to init playlist
		find $BGMa -iname "*.mp3" > /dev/shm/init
		cat /dev/shm/init | sort -n > /dev/shm/abc
		cat /dev/shm/init | sort --random-sort > /dev/shm/shuffle
	fi
	
	# Append init playlist if BGM B-SIDE flag 1
	if [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
		# Append B-SIDE to init playlist
		find $BGMb -iname "*.mp3" >> /dev/shm/init
		cat /dev/shm/init | sort -n > /dev/shm/abc
		cat /dev/shm/init | sort --random-sort > /dev/shm/shuffle
	fi
	
	# Escape the /\slashes/\ in the Paths
	ESCmusicROMS=${musicROMS//\//\\/}
	ESCmusicDIR=${musicDIR//\//\\/}
	
	# Replace rpMenu/music Path with roms/Music Path in Playlist files
	sed -i s+$ESCmusicDIR+$ESCmusicROMS+ /dev/shm/abc
	sed -i s+$ESCmusicDIR+$ESCmusicROMS+ /dev/shm/shuffle
	sed -i s+$ESCmusicDIR+$ESCmusicROMS+ /dev/shm/init
	
	# Compare New BGM Playlist with Current Playlist - Replace If Differences or NOT in accordance with BGM Flags
	cat $IMPPlaylist/init | sort -n > /dev/shm/abc-current
	if [ "$(diff /dev/shm/abc-current /dev/shm/abc)" == '' ]; then
		# No need to replace if Same Playlist and in accordance with BGM Flags
		rm /dev/shm/init
		rm /dev/shm/abc
		rm /dev/shm/abc-current
		rm /dev/shm/shuffle
	else
		# Replace current playlist in accordance with BGM Flags
		mv /dev/shm/init $IMPPlaylist/init
		mv /dev/shm/abc $IMPPlaylist/abc
		mv /dev/shm/shuffle $IMPPlaylist/shuffle
		rm /dev/shm/abc-current
	fi
fi

# If Shuffle @ B00T Flag 1 - Shuffle Current Playlist
if [ $(cat $IMPSettings/shuffleboot.flag) == "1" ]; then
	# Shuffle the Current Playlist
	sort --random-sort $IMPPlaylist/init > $IMPPlaylist/shuffle
	
	# Turning SHUFFLE On
	echo "1" > $IMPSettings/shuffle.flag
fi

# Start the Music Play Script
bash "$IMP/play.sh" &
exit 0
