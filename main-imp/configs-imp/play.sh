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

# Put something in [musicDIR] If No MP3s found at all - Exclude BGM Directories
for d in $(find $musicDIR -type d | grep -v $BGMa | grep -v $BGMb); do find $d -iname *.mp3 >> /dev/shm/tmpMP3; done
if [[ $(cat /dev/shm/tmpMP3) == '' ]]; then cp ~/RetroPie/retropiemenu/icons/impstartallm0.png "$musicDIR/CCCool.mp3" > /dev/null 2>&1; fi
rm /dev/shm/tmpMP3 > /dev/null 2>&1

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

# Disable Livewire if Not already
if [ ! -f ~/.DisableMusic ]; then touch ~/.DisableMusic; fi

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
	grep -FA $LINEcount "$mp3BASE" $IMPPlaylist/abc | grep -Fv "$mp3BASE" >> $IMPPlaylist/init
	grep -FB $LINEcount "$mp3BASE" $IMPPlaylist/abc | grep -Fv "$mp3BASE" >> $IMPPlaylist/init
	
	# Rebuild ABC Playlist with updated 0rder
	cat $IMPPlaylist/init > $IMPPlaylist/abc

	# Last track played Identified - Rebuild Shuffle Playlists with Last Track played First
	echo $PLfirst > $IMPPlaylist/init
	# Parse all lines after and before Last Track played
	grep -FA $LINEcount "$mp3BASE" $IMPPlaylist/shuffle | grep -Fv "$mp3BASE" >> $IMPPlaylist/init
	grep -FB $LINEcount "$mp3BASE" $IMPPlaylist/shuffle | grep -Fv "$mp3BASE" >> $IMPPlaylist/init
	
	# Rebuild Shuffle Playlist with updated 0rder
	cat $IMPPlaylist/init > $IMPPlaylist/shuffle
	# echo $PLfirst > $IMPPlaylist/shuffle
	# sort --random-sort $IMPPlaylist/init | grep -Fv "$PLfirst" >> $IMPPlaylist/shuffle
fi

# Start the Music Player Loop Script
bash "$IMP/mpg123loop.sh" &
exit 0
