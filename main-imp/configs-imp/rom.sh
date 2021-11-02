#!/bin/bash
mp3ROM=$1
mp3DIR=$(dirname "$1")
# Too Many Symbolic Links
if [ ! $(readlink "$mp3DIR") == '' ]; then mp3DIR=$(readlink "$mp3DIR"); fi
INITmp3BASE=$(basename "$1")
# Too Many Special Characters
mp3BASE=$(echo "$INITmp3BASE" | LC_ALL=C sed -e 's/[^a-zA-Z0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')

IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist

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
	# Replace [https://] with [http://] in playlist to overcome mpg123 error
	sudo sed -i s+'https://'+'http://'+ $IMPPlaylist/init
	
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
		find "$musicDIR" -maxdepth 1 -type f -name "*.mp3" | grep -Fv "$mp3BASE" >> $IMPPlaylist/abc
	else
		# Obtain First Track
		PLfirst=$(find "$mp3DIR" -maxdepth 1 -type f -iname "$mp3BASE" )
		# Add Remaining MP3s from selected MP3-ROM directory to Playlist Non-Recursive
		find "$mp3DIR" -maxdepth 1 -type f -name "*.mp3" | grep -Fv "$mp3BASE" >> $IMPPlaylist/abc
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
