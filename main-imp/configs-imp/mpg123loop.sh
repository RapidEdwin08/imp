#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
playerVOL=$(cat $IMPSettings/volume.flag)
if [ -f /dev/shm/lower-idle.volume ]; then playerVOL=$(cat /dev/shm/lower-idle.volume); rm /dev/shm/lower-idle.volume > /dev/null 2>&1; fi # 0ne-Time-Use Lower Volume Setting
httpSTREAM=$(head -qn1 $IMPPlaylist/abc | grep -q 'http:' ; echo $?)
# FULL MODE Write to Disk - LITE MODE Write to tmpfs - Recall Last Track/Position Lost on REBOOT using LITE MODE
if [ $(cat $IMPSettings/lite.flag) == "0" ]; then
	currentTRACK=$IMPPlaylist/current-track
else
	currentTRACK=/dev/shm/current-track
fi
musicDIR=~/RetroPie/retropiemenu/imp/music
BGMdir="$musicDIR/bgm"
startupMP3="$BGMdir/startup.mp3"
quitMP3="$BGMdir/quit.mp3"
startupTRACK=/dev/shm/startup-track

# [$IMP/mpg123loop.sh] runs with -continue -k to Continue from Last Frame Position pulled from [$currentTRACK] - Does NOT apply to HTTP
# If [$IMP/stop.sh] called with NO Argument - Start from the beginning by Setting Last Position > 0000+0000  00:00. > [$currentTRACK]
# If [$IMP/stop.sh] called with ANY Argument - Continue track from Last Position by NOT Setting Last Position > 0000+0000  00:00.

# STOP L00P if mpg123 NOT Installed
mpg123VER=$(mpg123 --version)
if [[ ! "$mpg123VER" == "mpg123 1."* ]]; then bash $IMP/stop.sh && exit 0; fi

# Check for LastFramePosition - If NOT found Set Last Position 0000+0000 manually - Does NOT apply to HTTP
if [ "$httpSTREAM" == '1' ]; then
	LastFramePosition="$(grep '>*+' $currentTRACK | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1)"
	
	# Most likely a New Track If LastFramePosition still NOT found
	if [[ "$LastFramePosition" == '' ]]; then
		# Clear Current Track Contents - Set Last Position 0000+0000
		echo "" > $currentTRACK
		echo -e '> 0000+0000  00:00.' >> $currentTRACK
	fi
fi

# https://github.com/RapidEdwin08/imp/issues/5 - Reported by gloony on Aug 16 2023
# Settings Flags *MOVED* - Startup/Quit Song Actions should NOT Touch the [music-switch.flag]
##echo '0' > $IMPSettings/pause.flag
##echo "1" > $IMPSettings/music-switch.flag

# Determine ABC or Shuffle Playlist from Settings Flags
if [ $(cat $IMPSettings/shuffle.flag) == "1" ]; then
	currentPLIST="$IMPPlaylist/shuffle"
else
	currentPLIST="$IMPPlaylist/abc"
fi

# Disable Livewire if Not already
if [ ! -f ~/.DisableMusic ]; then touch ~/.DisableMusic; fi

# [quitsong.play] - IF [2] Play [quit.mp3] then EXIT
if [ -f "$quitMP3" ] && [ $(cat $IMPSettings/quitsong.play) == "2" ]; then
	echo '0' > $IMPSettings/quitsong.play
	mpg123 -v -f "$playerVOL" "$quitMP3" > $startupTRACK 2>&1
	rm $startupTRACK
	exit 0
fi
# [quitsong.play] - IF [3] Play [quit.mp3] - Re0rganize Playlist around Current Playing Track and Continue
if [ -f "$quitMP3" ] && [ $(cat $IMPSettings/quitsong.play) == "3" ]; then
	echo '0' > $IMPSettings/quitsong.play
	mpg123 -v -f "$playerVOL" "$quitMP3" > $startupTRACK 2>&1
	rm $startupTRACK
	bash "$IMP/play.sh" &
	exit 0
fi

# [startupsong.play] - IF [1] Play [startup.mp3]
if [ -f "$startupMP3" ] && [ $(cat $IMPSettings/startupsong.play) == "1" ]; then
	echo '0' > $IMPSettings/startupsong.play
	mpg123 -v -f "$playerVOL" "$startupMP3" > $startupTRACK 2>&1
	rm $startupTRACK
fi
# [startupsong.play] - IF [2] Play [startup.mp3] then EXIT - music startup flag [0]
if [ -f "$startupMP3" ] && [ $(cat $IMPSettings/startupsong.play) == "2" ]; then
	echo '0' > $IMPSettings/startupsong.play
	mpg123 -v -f "$playerVOL" "$startupMP3" > $startupTRACK 2>&1
	rm $startupTRACK
	exit 0
fi
# [startupsong.play] - IF [3] Play [startup.mp3] - Re0rganize Playlist around Current Playing Track and Continue
if [ -f "$startupMP3" ] && [ $(cat $IMPSettings/startupsong.play) == "3" ]; then
	echo '0' > $IMPSettings/startupsong.play
	mpg123 -v -f "$playerVOL" "$startupMP3" > $startupTRACK 2>&1
	rm $startupTRACK
	bash "$IMP/play.sh" &
	exit 0
fi

# [music-switch.flag] Settings Flags AFTER Startup/Quit Song Actions
echo '0' > $IMPSettings/pause.flag
echo "1" > $IMPSettings/music-switch.flag

# [IMP] FULL MODE - Always Logging while Playing - Full Features
if [ ! $(cat $IMPSettings/infinite.flag) == "0" ]; then
	# Play INFINITE Loop all songs in Playlist  iMP
	while [ $(cat $IMPSettings/music-switch.flag) == "1" ]; do
		if [ "$httpSTREAM" == '0' ]; then
			# mpg123 withOUT -v to Limit the verbosity level If HTTP Stream - Limits Log file size of Long Streams - Frame numbers can not be used to Continue a Stream
			while read line; do mpg123 -f "$playerVOL" "$line" > $currentTRACK 2>&1 && bash "$IMP/errorcheck.sh"; done < $currentPLIST
		else
			# mpg123 WITH - v to Increase the verbosity level and obtain the frame numbers
			# --continue -k to Continue from Last Frame Position from [$currentTRACK]
			# Obtain the LastFramePosition="$(grep '>*+' $currentTRACK | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1)"
			while read line; do mpg123 -v --continue -k $(grep '>*+' $currentTRACK | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1) -f "$playerVOL" "$line" > $currentTRACK 2>&1 && bash "$IMP/errorcheck.sh"; done < $currentPLIST
		fi
		bash "$IMP/nextalbum.sh" & exit 0
	done  > /dev/null 2>&1 &
	exit 0
else
	# Play all songs in Playlist
	if [ "$httpSTREAM" == '0' ]; then
		# mpg123 withOUT -v to Limit the verbosity level If HTTP Stream - Limits Log file size of Long Streams - Frame numbers can not be used to Continue a Stream
		while read line; do mpg123 -f "$playerVOL" "$line" > $currentTRACK 2>&1 && bash "$IMP/errorcheck.sh"; done < $currentPLIST  > /dev/null 2>&1 &
	else
		# mpg123 WITH - v to Increase the verbosity level and obtain the frame numbers
		# --continue -k to Continue from Last Frame Position from [$currentTRACK]
		# Obtain the LastFramePosition="$(grep '>*+' $currentTRACK | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1)"
		while read line; do mpg123 -v --continue -k $(grep '>*+' $currentTRACK | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1) -f "$playerVOL" "$line" > $currentTRACK 2>&1 && bash "$IMP/errorcheck.sh"; done < $currentPLIST  > /dev/null 2>&1 &
	fi
	exit 0
fi

exit 0
