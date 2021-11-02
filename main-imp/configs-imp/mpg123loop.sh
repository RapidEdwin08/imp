#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
playerVOL=$(cat $IMPSettings/volume.flag)
httpSTREAM=$(head -qn1 $IMPPlaylist/abc | grep -q 'http:' ; echo $?)

# [$IMP/mpg123loop.sh] runs with -continue -k to Continue from Last Frame Position pulled from [$IMPPlaylist/current-track] - Does NOT apply to LITE MODE or HTTP
# If [$IMP/stop.sh] called with NO Argument - Start from the beginning by Setting Last Position > 0000+0000  00:00. > [$IMPPlaylist/current-track]
# If [$IMP/stop.sh] called with ANY Argument - Continue track from Last Position by NOT Setting Last Position > 0000+0000  00:00.

# Check for LastFramePosition - If NOT found Set Last Position 0000+0000 manually - Does NOT apply to LITE MODE or HTTP
if [ $(cat $IMPSettings/lite.flag) == "0" ] || [ "$httpSTREAM" == '1' ]; then
	LastFramePosition="$(grep '>*+' $IMPPlaylist/current-track | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1)"
	
	# Most likely a New Track If LastFramePosition still NOT found
	if [[ "$LastFramePosition" == '' ]]; then
		# Clear Current Track Contents - Set Last Position 0000+0000
		echo "" > $IMPPlaylist/current-track
		echo -e '> 0000+0000  00:00.' >> $IMPPlaylist/current-track
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

# [IMP] LITE MODE - No Logging - Limited Features
if [ $(cat $IMPSettings/lite.flag) == "1" ]; then
	if [ $(cat $IMPSettings/infinite.flag) == "1" ]; then
		# Play INFINITE Loop all songs in Playlist  iMP
		while [ $(cat $IMPSettings/music-switch.flag) == "1" ]; do
			while read line; do mpg123 -f "$playerVOL" "$line" > /dev/null 2>&1; done < $currentPLIST
		done &
		exit 0
	else
		# Play all songs in Playlist
		while read line; do mpg123 -f "$playerVOL" "$line" > /dev/null 2>&1; done < $currentPLIST &
		exit 0
	fi
fi

# [IMP] FULL MODE - Always Logging while Playing - Full Features
if [ $(cat $IMPSettings/infinite.flag) == "1" ]; then
	# Play INFINITE Loop all songs in Playlist  iMP
	while [ $(cat $IMPSettings/music-switch.flag) == "1" ]; do
		if [ "$httpSTREAM" == '0' ]; then
			# mpg123 withOUT -v to Limit the verbosity level If HTTP Stream - Limits Log file size of Long Streams - Frame numbers can not be used to Continue a Stream
			while read line; do mpg123 -f $playerVOL "$line" > $IMPPlaylist/current-track 2>&1 && bash "$IMP/errorcheck.sh"; done < $currentPLIST
		else
			# mpg123 WITH - v to Increase the verbosity level and obtain the frame numbers
			# --continue -k to Continue from Last Frame Position from [$IMPPlaylist/current-track]
			# Obtain the LastFramePosition="$(grep '>*+' $IMPPlaylist/current-track | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1)"
			while read line; do mpg123 -v --continue -k $(grep '>*+' $IMPPlaylist/current-track | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1) -f "$playerVOL" "$line" > $IMPPlaylist/current-track 2>&1 && bash "$IMP/errorcheck.sh"; done < $currentPLIST
		fi
	done &
	exit 0
else
	# Play all songs in Playlist
	if [ "$httpSTREAM" == '0' ]; then
		# mpg123 withOUT -v to Limit the verbosity level If HTTP Stream - Limits Log file size of Long Streams - Frame numbers can not be used to Continue a Stream
		while read line; do mpg123 -f $playerVOL "$line" > $IMPPlaylist/current-track 2>&1 && bash "$IMP/errorcheck.sh"; done < $currentPLIST &
		exit 0
	else
		# mpg123 WITH - v to Increase the verbosity level and obtain the frame numbers
		# --continue -k to Continue from Last Frame Position from [$IMPPlaylist/current-track]
		# Obtain the LastFramePosition="$(grep '>*+' $IMPPlaylist/current-track | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1)"
		while read line; do mpg123 -v --continue -k $(grep '>*+' $IMPPlaylist/current-track | tail -1 | sed -n -e 's/^.*> //p' | cut -d '+' -f 1) -f "$playerVOL" "$line" > $IMPPlaylist/current-track 2>&1 && bash "$IMP/errorcheck.sh"; done < $currentPLIST &
		exit 0
	fi
fi

exit 0
