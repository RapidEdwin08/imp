#!/bin/bash
mp3ROM=$1
mp3DIR=$(dirname "$1")
# Too Many Symbolic Links
if [ ! $(readlink "$mp3DIR") == '' ]; then mp3DIR=$(readlink "$mp3DIR"); fi
INITmp3BASE=$(basename "$1")
# Too Many Special Characters
mp3BASE=$(echo "$INITmp3BASE" | LC_ALL=C sed -e 's/[^a-zA-ZöÖóÓòÒôÔñÑÇçŒœßØøÅåÆæÞþÐð«»¢£¥€¤0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')

IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist

musicDIR=~/RetroPie/retropiemenu/imp/music
musicROMS=~/RetroPie/roms/music
BGMdir="$musicDIR/bgm"
BGMa="$musicDIR/bgm/A-SIDE"
BGMb="$musicDIR/bgm/B-SIDE"

# Startup Song should Not interrupt Current Playlist
if [[ "$mp3ROM" == *"imp/music/bgm/startup.mp3" ]]; then
	# Continue Playback after Startup Song
	if [[ $(cat $IMPSettings/music-switch.flag) == "1" ]]; then
		# Stop mpg123loop with continue parameter
		bash "$IMP/stop.sh" continue > /dev/null 2>&1
		echo '1' > $IMPSettings/startupsong.play
		bash "$IMP/mpg123loop.sh" &
		exit 0
	else
		# Exit Playback after Startup Song
		# Stop mpg123loop with continue parameter in case Paused
		bash "$IMP/stop.sh" continue > /dev/null 2>&1
		echo '2' > $IMPSettings/startupsong.play
		bash "$IMP/mpg123loop.sh" &
		exit 0
	fi
fi

# Stop instances of mpg123 
bash "$IMP/stop.sh" > /dev/null 2>&1

# Clear Playlist Files
cat /dev/null > $IMPPlaylist/init
cat /dev/null > $IMPPlaylist/abc
cat /dev/null > $IMPPlaylist/shuffle
# cat /dev/null > $IMPPlaylist/current-track

# Build INIT and ABC Playists - Parse .pls and .m3u files first
if [[ "$mp3BASE" == *".pls" || "$mp3BASE" == *".m3u" ]]; then
	# If .pls file Obtain All Lines that Begin with File#=
	if [[ "$mp3BASE" == *".pls" ]]; then grep '^File' "$mp3ROM" | sed 's/.*=//' > $IMPPlaylist/init; fi
	
	# If .m3u file Obtain All Lines that Begin with http
	if [[ "$mp3BASE" == *".m3u" ]]; then grep '^http' "$mp3ROM" > $IMPPlaylist/init; fi
	
	# *ISSUE* - https not working with mpg123 - main: [src/mpg123.c:708] error: Cannot open https://...-mp3: File access error. (code 22)
	# Recently Internet Radio Stations are updating thier stream servers to SSL TLSv1.3...
	# Replace [https://] with [http://] and *Remove [:443]* in playlist to overcome mpg123 error
	sed -i s+'https://'+'http://'+ $IMPPlaylist/init
	sed -i s+':443'+''+ $IMPPlaylist/init
	
	# Obtain First Track
	PLfirst=$(head -n 1 $IMPPlaylist/init)
	
	# Rebuild .pls ABC Playlist - Maintain the .pls/.m3u List 0rder
	cat $IMPPlaylist/init > $IMPPlaylist/abc
else	
	# Build INIT and ABC Playists - Parse .mp3 files
	if [ "$mp3DIR" == "$musicROMS" ]; then
		# Obtain First Track
		PLfirst=$(find "$musicDIR" -maxdepth 1 -type f -iname "$mp3BASE" )
		# Add Remaining MP3s from the musicDIR directory to Playlist Non-Recursive
		find "$musicDIR" -maxdepth 1 -type f -name "*.mp3" | grep -Fv "$mp3BASE" | grep -v 'imp/music/bgm/startup.mp3' >> $IMPPlaylist/abc
	else
		# Obtain First Track
		PLfirst=$(find "$mp3DIR" -maxdepth 1 -type f -iname "$mp3BASE" )
		# Add Remaining MP3s from selected MP3-ROM directory to Playlist Non-Recursive
		find "$mp3DIR" -maxdepth 1 -type f -name "*.mp3" | grep -Fv "$mp3BASE" | grep -v 'imp/music/bgm/startup.mp3' >> $IMPPlaylist/abc
	fi

	# Sort init playlist
	sort $IMPPlaylist/abc -n > $IMPPlaylist/init
	
	# Determine # of Lines - Shortens the amount of time it takes to Parse Lines with grep
	LINEcount=$(grep -c ".*" $IMPPlaylist/init)
	
	# Rebuild ABC Playlist now in ABC 0rder - Selected MP3-ROM first
	echo $PLfirst > $IMPPlaylist/abc
	# Parse all lines after and before Selected MP3-ROM
	grep -FA $LINEcount "$INITmp3BASE" $IMPPlaylist/init | grep -Fv "$INITmp3BASE" >> $IMPPlaylist/abc
	grep -FB $LINEcount "$INITmp3BASE" $IMPPlaylist/init | grep -Fv "$INITmp3BASE" >> $IMPPlaylist/abc
	
	# *ISSUE* - Obtain 1st/2nd Half with grep Sometimes FAILS - Fall back to ABC order with mp3BASE 1st in Playists
	if [ "$(grep -FA $LINEcount "$INITmp3BASE" $IMPPlaylist/init | grep -Fv "$INITmp3BASE" )" == '' ] && [ "$(grep -FB $LINEcount "$INITmp3BASE" $IMPPlaylist/init | grep -Fv "$INITmp3BASE" )" == '' ]; then
		sort $IMPPlaylist/init -n | grep -Fv "$INITmp3BASE" >> $IMPPlaylist/abc
	fi
fi

# Build Shuffle Playlist - Selected MP3-ROM first
echo $PLfirst > $IMPPlaylist/shuffle
sort --random-sort $IMPPlaylist/init | grep -Fv "$PLfirst" >> $IMPPlaylist/shuffle

# Start the Music Player Loop Script
bash "$IMP/mpg123loop.sh" &
exit 0
