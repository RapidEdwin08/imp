#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# FULL MODE Write to Disk - LITE MODE Write to tmpfs - Recall Last Track/Position Lost on REBOOT using LITE MODE
if [ $(cat $IMPSettings/lite.flag) == "0" ]; then
	currentTRACK=$IMPPlaylist/current-track
else
	currentTRACK=/dev/shm/current-track
fi

# Disable Livewire if Not already
if [ ! -f ~/.DisableMusic ]; then touch ~/.DisableMusic; fi

# IF startupsong enabled but music at startup is disabled then SKIP Playlist Rebuild
if [ $(cat $IMPSettings/startupsong.play) == "2" ]; then
	# Skip the Playlist sorting
	bash "$IMP/mpg123loop.sh" &
	exit 0
fi

# Start 0mxmon here if Needed - almost all IMP scripts call play.sh
if [[ $(cat /opt/retropie/configs/imp/settings/0mxmon.flag) == "1" ]] && [[ ! -f /dev/shm/0mxMonLoop.Active ]]; then
	bash "$IMP/0mxmon.sh" &
fi

# Continue mpg123 if coming from a Paused state
result=`pgrep mpg123`
if [[ "$result" == '' ]]; then
	# disable flag to stop loop
	echo "0" > $IMPSettings/music-switch.flag
else
    echo "1" > $IMPSettings/music-switch.flag
	echo "0" > $IMPSettings/pause.flag
	pkill -CONT mpg123
    exit 0
fi

# Skip Recall Last Track/Position if currentTRACK NOT found
if [ ! -f $currentTRACK ]; then
	# Start the Music Player Loop Script
	bash "$IMP/mpg123loop.sh" &
	exit 0
fi

# Parse Current Track file to obtain Last track played - Cut off the last x4 characters
# Expected Result MP3: Playing MPEG stream 1 of 1: Song.mp3 ...
# Expected Result Stream: Playing MPEG stream 1 of 1: lush-128-mp3 ...
mp3LAST=$(grep -iE 'Playing MPEG stream' $currentTRACK | cut -b 29-999 | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop')

# Expected Result  Directory: /home/pi/RetroPie/roms/music/
# Expected Result  Directory: http://ice1.somafm.com/
dirBASE=$(grep -iE 'Directory:' $currentTRACK | cut -b 12-999)

# Expected Result mp3: /home/pi/RetroPie/roms/music/Song.mp3
# Expected Result stream http://ice1.somafm.com/lush-128-mp3
mp3BASE=$dirBASE$mp3LAST

# Determine ABC or Shuffle Playlist from Settings Flags
if [ $(cat $IMPSettings/shuffle.flag) == "1" ]; then
	currentPLIST="$IMPPlaylist/shuffle"
else
	currentPLIST="$IMPPlaylist/abc"
fi

# If Last Track bLANK Substitute with first Line in ABC Playlist
CLfirst=$(head -qn1 $currentPLIST)
if [[ "$mp3BASE" == '' ]]; then mp3BASE=$CLfirst; fi

# Identify Last track played - will be added first to current playlist
while read line; do
	if [[ $line == *"$mp3BASE"* ]]; then PLfirst=$line; fi
done < $IMPPlaylist/abc

# 2nd attempt to Identify Last track played - For Sybolic Links Search less strict - dirBASE could differ
# HTTP Excluded in less scrict search - dirBASE could be identical
if [[ "$PLfirst" == '' ]] && [[ ! "$dirBASE" == "http"* ]]; then 
while read line; do
	if [[ $line == *"$mp3LAST"* ]]; then
		PLfirst=$line
		# For Sybolic Links
		mp3BASE=$line
	fi
done < $IMPPlaylist/abc
fi

# Skip Playlist Rebuild if Current Track is 1st in Current Playlist
if [[ "$PLfirst" == "$(head -qn1 $currentPLIST)" ]]; then
	# Start the Music Player Loop Script
	bash "$IMP/mpg123loop.sh" &
	exit 0
fi

# Determine # of Lines - Shortens the amount of time it takes to Parse Lines with grep
LINEcount=$(grep -c ".*" $currentPLIST)

# Last track played NOT Identified - Do NOT Rebuild Playlist - Maintain the 0rder
if [[ "$PLfirst" == '' ]]; then
	# Last Position 0000 If Last Track not found or Not in Current Playlist
 	echo "" >> $currentTRACK
 	echo -e '> 0000+0000' >> $currentTRACK
else
	# Last track played Identified - Rebuild ABC Playlists with Last Track played First
	echo $PLfirst > $IMPPlaylist/init
	# Parse all lines after and before Last Track played
	grep -FA $LINEcount "$mp3BASE" $IMPPlaylist/abc | grep -Fv "$mp3BASE" | grep -v 'imp/music/bgm/startup.mp3' >> $IMPPlaylist/init
	grep -FB $LINEcount "$mp3BASE" $IMPPlaylist/abc | grep -Fv "$mp3BASE" | grep -v 'imp/music/bgm/startup.mp3' >> $IMPPlaylist/init
	
	# Rebuild ABC Playlist with updated 0rder
	cat $IMPPlaylist/init > $IMPPlaylist/abc

	# Last track played Identified - Rebuild Shuffle Playlists with Last Track played First
	echo $PLfirst > $IMPPlaylist/init
	# Parse all lines after and before Last Track played
	grep -FA $LINEcount "$mp3BASE" $IMPPlaylist/shuffle | grep -Fv "$mp3BASE" | grep -v 'imp/music/bgm/startup.mp3' >> $IMPPlaylist/init
	grep -FB $LINEcount "$mp3BASE" $IMPPlaylist/shuffle | grep -Fv "$mp3BASE" | grep -v 'imp/music/bgm/startup.mp3' >> $IMPPlaylist/init
	
	# Rebuild Shuffle Playlist with updated 0rder
	cat $IMPPlaylist/init > $IMPPlaylist/shuffle
	# echo $PLfirst > $IMPPlaylist/shuffle
	# sort --random-sort $IMPPlaylist/init | grep -Fv "$PLfirst" >> $IMPPlaylist/shuffle
fi

# Start the Music Player Loop Script
bash "$IMP/mpg123loop.sh" &
exit 0
