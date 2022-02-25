#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
playerVOL=$(cat $IMPSettings/volume.flag)
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

# Settings Flags
echo '0' > $IMPSettings/pause.flag
echo "1" > $IMPSettings/music-switch.flag

# Determine ABC or Shuffle Playlist from Settings Flags
if [ $(cat $IMPSettings/shuffle.flag) == "1" ]; then
	currentPLIST="$IMPPlaylist/shuffle"
else
	currentPLIST="$IMPPlaylist/abc"
fi

# Disable Livewire if Not already
if [ ! -f ~/.DisableMusic ]; then touch ~/.DisableMusic; fi

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

# [IMP] FULL MODE - Always Logging while Playing - Full Features
if [ $(cat $IMPSettings/infinite.flag) == "1" ]; then
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
	done &
	exit 0
else
	# Play all songs in Playlist
	if [ "$httpSTREAM" == '0' ]; then
		# mpg123 withOUT -v to Limit the verbosity level If HTTP Stream - Limits Log file size of Long Streams - Frame numbers can not be used to Continue a Stream
		while read line; do mpg123 -f "$playerVOL" "$line" > $currentTRACK 2>&1 && bash "$IMP/errorcheck.sh"; done < $currentPLIST &
		exit 0
	else
		# mpg123 WITH - v to Increase the verbosity level and obtain the frame numbers
		# --continue -k to Continue from Last Frame Position from [$currentTRACK]
		# Obtain the LastFramePosition="$(grep '>*+' $currentTRACK | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1)"
		while read line; do mpg123 -v --continue -k $(grep '>*+' $currentTRACK | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1) -f "$playerVOL" "$line" > $currentTRACK 2>&1 && bash "$IMP/errorcheck.sh"; done < $currentPLIST &
		exit 0
	fi
fi

exit 0
