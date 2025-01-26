#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# musicDIR=$(readlink ~/RetroPie/retropiemenu/imp/music) # ES does not play well with Symbolic Links in [retropiemenu]
musicDIR=~/RetroPie/retropiemenu/imp/music
ROMSmusicDIR=~/RetroPie/roms/music
BGMdir="$musicDIR/bgm"
BGMa="$musicDIR/bgm/A-SIDE"
BGMb="$musicDIR/bgm/B-SIDE"

# FULL MODE Write to Disk - LITE MODE Write to tmpfs - Recall Last Track/Position Lost on REBOOT using LITE MODE
if [ $(cat $IMPSettings/lite.flag) == "0" ]; then
	currentTRACK=$IMPPlaylist/current-track
else
	currentTRACK=/dev/shm/current-track
fi
trackFILE=$(grep -iE 'Playing MPEG stream' $currentTRACK | cut -b 28-999 | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop')
httpSTREAM=$(head -qn1 $IMPPlaylist/abc | grep -q 'http:' ; echo $?)

# Determine ABC or Shuffle Playlist from Settings Flags
##if [ $(cat $IMPSettings/shuffle.flag) == "1" ]; then # Randomizer@Boot is now Shuffle@Boot 202501*
if [ $(cat $IMPSettings/randomizerboot.flag) == "1" ]; then
	currentPLIST=$IMPPlaylist/shuffle
	tmpPLIST=/dev/shm/shuffle
else
	currentPLIST=$IMPPlaylist/abc
	tmpPLIST=/dev/shm/abc
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

# Stop mpg123loop
bash "$IMP/stop.sh" > /dev/null 2>&1

###################

m3uPLS()
{
# Find [.pls/.m3u] Files
INITmp3BASE=$(basename "$mp3BASE")
# Too Many Special Characters
mp3BASE=$(echo "$INITmp3BASE" | LC_ALL=C sed -e 's/[^a-zA-ZöÖóÓòÒôÔñÑÇçŒœßØøÅåÆæÞþÐð«»¢£¥€¤0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')

find "$musicDIR" -maxdepth 1 -type f -iname "*.pls" > /dev/shm/pls
find "$musicDIR"/*/ -iname "*.pls" > /dev/shm/pls
find "$musicDIR" -maxdepth 1 -type f -iname "*.m3u" >> /dev/shm/pls
find "$musicDIR"/*/ -iname "*.m3u" >> /dev/shm/pls
while read line; do
	if [[ ! "$( cat "$line" | grep "$dirBASE$mp3BASE" )" == '' ]]; then httpLAST="$line"; fi
done < /dev/shm/pls

if [[ "$httpLAST" == '' ]]; then
while read line; do
	if [[ ! "$( cat "$line" | grep "$mp3LAST" )" == '' ]]; then httpLAST=$line; fi
done < /dev/shm/pls
fi

mp3BASE=$httpLAST
cat /dev/shm/pls | sort -n > /dev/shm/init
rm /dev/shm/pls
}

allMUSIC()
{
# BGM Flags AB
if [ $(cat $IMPSettings/a-side.flag) == "1" ] && [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	# Find Random [.mp3] - ALL+BGM_AB
	find "$musicDIR" -maxdepth 1 -type f -iname "*.mp3"  | grep -vi .m3u | grep -vi .pls | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 > /dev/shm/init
	find "$musicDIR"/*/ -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 >> /dev/shm/init
fi

# BGM Flags A
if [ $(cat $IMPSettings/a-side.flag) == "1" ] && [ $(cat $IMPSettings/b-side.flag) == "0" ]; then
	# Find Random [.mp3] - ALL+BGM_A
	find "$musicDIR" -maxdepth 1 -type f -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/B-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 > /dev/shm/init
	find "$musicDIR"/*/ -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/B-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 >> /dev/shm/init
fi

# BGM Flags B
if [ $(cat $IMPSettings/a-side.flag) == "0" ] && [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	# Find Random [.mp3] - ALL+BGM_B
	find "$musicDIR" -maxdepth 1 -type f -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/A-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 > /dev/shm/init
	find "$musicDIR"/*/ -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/A-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 >> /dev/shm/init
fi

# BGM Flags ' '
if [ $(cat $IMPSettings/a-side.flag) == "0" ] && [ $(cat $IMPSettings/b-side.flag) == "0" ]; then
	# Find Random [.mp3] - ALL (NO BGM)
	find "$musicDIR" -maxdepth 1 -type f -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/A-SIDE/" | grep -v "/bgm/B-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 > /dev/shm/init
	find "$musicDIR"/*/ -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/A-SIDE/" | grep -v "/bgm/B-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 >> /dev/shm/init
fi
}

# Generate init Playlist of ALL Available .mp3
if [ "$httpSTREAM" == '0' ]; then
	m3uPLS
else
	allMUSIC
fi

# Rebuild ABC and Shuffle Playlists with updated 0rder
cat /dev/shm/init | sort -n > /dev/shm/abc
cat /dev/shm/init | sort --random-sort > /dev/shm/shuffle

###################

# If Last Track bLANK Substitute with first Line in ABC Playlist
if [[ "$mp3BASE" == '' ]]; then mp3BASE=$(head -qn1 $tmpPLIST); fi

# Determine # of Lines - Shortens the amount of time it takes to Parse Lines with grep
LINEcount=$(grep -c ".*" $tmpPLIST)

if [ "$httpSTREAM" == '0' ]; then
	# Parse all lines after and before Last Track played - Don't FIlter out same Directory for [.pls/.m3u] Files
	grep -FA $LINEcount "$mp3BASE" $tmpPLIST | grep -v "$mp3BASE" > /dev/shm/init
	grep -FB $LINEcount "$mp3BASE" $tmpPLIST | grep -v "$mp3BASE" >> /dev/shm/init
elif [[ "$dirBASE" == "$ROMSmusicDIR/" ]]; then
	# Remove all lines that include _roms_music
	cat /dev/shm/abc | grep -v "$ROMSmusicDIR/" | grep -v "_roms_music" > /dev/shm/init
else
	# Parse all lines after and before Last Track played - FIlter out anything in the same Directory
	grep -FA $LINEcount "$mp3LAST" $tmpPLIST | grep -v "$mp3LAST" | grep -v "$dirBASE" > /dev/shm/init
	grep -FB $LINEcount "$mp3LAST" $tmpPLIST | grep -v "$mp3LAST" | grep -v "$dirBASE" >> /dev/shm/init
fi

# If nothing Parse all lines after and before Last Track played again - Alternate FIlter
if [[ "$(cat /dev/shm/init)" == '' ]]; then
	cat $tmpPLIST > /dev/shm/init
fi

###################
# nextTRACK obtained from filtered down list
# Get nextTRACK for Stream from the Last Line
if [ "$httpSTREAM" == '0' ]; then
	nextTRACK=$(tail -n 1 /dev/shm/init)
else
	# Get Folder Folder from Last Line - Get nextTRACK for MP3 from the 1st Line
	nextDIR=$(dirname "$(tail -n 1 /dev/shm/init)")
	cat /dev/shm/init | grep "$nextDIR" > /dev/shm/pls
	if [ $(cat $IMPSettings/shuffle.flag) == "1" ]; then
		cat /dev/shm/pls | sort --random-sort > /dev/shm/init
	else
		cat /dev/shm/pls | sort -n > /dev/shm/init
	fi
	nextTRACK=$(head -qn1 /dev/shm/init)
fi

# Clean up
rm /dev/shm/abc 2>/dev/null; rm /dev/shm/shuffle 2>/dev/null; rm /dev/shm/init 2>/dev/null

# Run Randomizer if still nothing
if [ "$nextTRACK" == '' ]; then bash "$IMP/randomizer.sh" & exit 0; fi

# Start the Music Player Loop Script
bash "$IMP/rom.sh" "$nextTRACK" &
exit 0
