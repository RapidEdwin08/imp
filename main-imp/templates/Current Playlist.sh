#!/bin/bash
tput reset
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
musicDIR=~/RetroPie/retropiemenu/imp/music
# FULL MODE Write to Disk - LITE MODE Write to tmpfs - Recall Last Track/Position Lost on REBOOT using LITE MODE
if [ $(cat $IMPSettings/lite.flag) == "0" ]; then
	currentTRACK=$IMPPlaylist/current-track
	trackTIME=$(grep '>*+' /opt/retropie/configs/imp/playlist/current-track 2>/dev/null | tail -1 | sed -n -e 's/^.*> //p' |awk '{print $2}' | cut -d '.' -f 1)
else
	currentTRACK=/dev/shm/current-track
	trackTIME=$(grep '>*+' /dev/shm/current-track 2>/dev/null | tail -1 | sed -n -e 's/^.*> //p' |awk '{print $2}' | cut -d '.' -f 1)
fi
# Startup Song
if [ -f /dev/shm/startup-track ]; then
	currentTRACK=/dev/shm/startup-track
	trackTIME=$(grep '>*+' /dev/shm/startup-track | tail -1 | sed -n -e 's/^.*> //p' |awk '{print $2}' | cut -d '.' -f 1)
fi

trackFILE=$(grep -iE 'Playing MPEG stream' $currentTRACK 2>/dev/null | cut -b 28-999 | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop')
trackTITLE=$(grep -iE 'Title:' $currentTRACK 2>/dev/null); if [ $trackTITLE == 'Title:' 2>/dev/null ]; then trackTITLE=''; fi
trackALBUM=$(grep -iE 'Album:' $currentTRACK 2>/dev/null); if [ $trackALBUM == 'Album:' 2>/dev/null ]; then trackALBUM=''; fi
trackYEAR=$(grep -iE 'Year:' $currentTRACK 2>/dev/null); if [ $trackYEAR == 'Year:' 2>/dev/null ]; then trackYEAR=''; fi
trackARTIST=$(grep -iE 'Artist:' $currentTRACK 2>/dev/null); if [ $trackARTIST == 'Artist:' 2>/dev/null ]; then trackARTIST=''; fi
playerVOL=$(cat $IMPSettings/volume.flag)
if [ $playerVOL == "32768" ]; then volume_percent="%100"; fi
if [ $playerVOL == "29484" ]; then volume_percent="%90"; fi
if [ $playerVOL == "26208" ]; then volume_percent="%80"; fi
if [ $playerVOL == "22932" ]; then volume_percent="%70"; fi
if [ $playerVOL == "19656" ]; then volume_percent="%60"; fi
if [ $playerVOL == "16380" ]; then volume_percent="%50"; fi
if [ $playerVOL == "13104" ]; then volume_percent="%40"; fi
if [ $playerVOL == "9828" ]; then volume_percent="%30"; fi
if [ $playerVOL == "6552" ]; then volume_percent="%20"; fi
if [ $playerVOL == "3276" ]; then volume_percent="%10"; fi
if [ $playerVOL == "1638" ]; then volume_percent="%5"; fi
if [ $playerVOL == "0000" ]; then volume_percent="MUTE"; fi

# Parse Current Track file to obtain Last track played - Cut off the last x4 characters
# Expected Result MP3: Playing MPEG stream 1 of 1: Song.mp3 ...
# Expected Result Stream: Playing MPEG stream 1 of 1: lush-128-mp3 ...
mp3LAST=$(grep -iE 'Playing MPEG stream' $currentTRACK 2>/dev/null | cut -b 29-999 | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop')

# Expected Result  Directory: /home/pi/RetroPie/roms/music/
# Expected Result  Directory: http://ice1.somafm.com/
dirBASE=$(grep -iE 'Directory:' $currentTRACK 2>/dev/null | cut -b 12-999)

# Expected Result mp3: /home/pi/RetroPie/roms/music/Song.mp3
# Expected Result stream http://ice1.somafm.com/lush-128-mp3
mp3BASE=$dirBASE$mp3LAST

currentBASE=$(echo "$dirBASE" | awk -v FS="retropiemenu/imp/" '{print $2}' )
if [[ "$currentBASE" == '' ]]; then currentBASE=$(echo "$dirBASE" | awk -v FS="/RetroPie/" '{print $2}' ); fi

streamURL=$(grep -iE 'ICY-URL:' $currentTRACK 2>/dev/null | cut -b 10-999)
streamNAME=$(grep -iE 'ICY-NAME:' $currentTRACK 2>/dev/null | cut -b 11-999)
streamTITLE=$(grep -iE 'StreamTitle=' $currentTRACK 2>/dev/null | cut -b 23-999 | cut -d ';' -f 1 )
pausemode=$(cat $IMPSettings/pause.flag)
if [[ $pausemode == "1" || $pausemode == "2" ]]; then pausemode="\Z3\ZbPAUSED\Zn"; else pausemode="\Z2PLAYING\Zn"; fi

infinite_mode=$(cat $IMPSettings/infinite.flag)
if [ $infinite_mode == "0" ]; then infinite_mode="OFF"; fi
if [ $infinite_mode == "1" ]; then infinite_mode="1"; fi
if [ $infinite_mode == "2" ]; then infinite_mode="ALL"; fi

if [ $(cat $IMPSettings/shuffle.flag) == "1" ]; then
	currentLIST=$IMPPlaylist/shuffle
	shuffleMODE="ON"
else
	currentLIST=$IMPPlaylist/abc
	shuffleMODE="OFF"
fi

httpSTREAM=$(head -qn1 $IMPPlaylist/abc | grep -q 'http:' ; echo $?)
if [ "$httpSTREAM" == '0' ]; then
	# Find [.pls/.m3u] Files
	INITmp3BASE=$(basename "$mp3BASE")
	# Too Many Special Characters
	mp3BASE=$(echo "$INITmp3BASE" | LC_ALL=C sed -e 's/[^a-zA-ZöÖóÓòÒôÔñÑÇçŒœßØøÅåÆæÞþÐð«»¢£¥€¤0-9,._+@%/-]/\\&/g; 1{$s/^$/""/}; 1!s/^/"/; $!s/$/"/')
	
	find "$musicDIR" -maxdepth 1 -type f -iname "*.pls" > /dev/shm/pls
	find "$musicDIR"/*/ -iname "*.pls" > /dev/shm/pls
	find "$musicDIR" -maxdepth 1 -type f -iname "*.m3u" >> /dev/shm/pls
	find "$musicDIR"/*/ -iname "*.m3u" >> /dev/shm/pls
	while read line; do
		if [[ ! "$( cat "$line" | grep "$dirBASE$mp3BASE" )" == '' ]]; then currentLAST="$line"; currentPLS=$(basename $line); currentPLSdir=$(echo "$line" | awk -v FS="retropiemenu/imp/" '{print $2}' ); if [[ "$currentPLSdir" == '' ]]; then currentPLSdir=$(echo "$line" | awk -v FS="/RetroPie/" '{print $2}' ); fi; fi
	done < /dev/shm/pls
	
	if [[ "$currentLAST" == '' ]]; then
		while read line; do
			if [[ ! "$( cat "$line" | grep "$mp3LAST" )" == '' ]]; then currentLAST="$line"; currentPLS=$(basename $line); currentPLSdir=$(echo "$line" | awk -v FS="retropiemenu/imp/" '{print $2}' ); if [[ "$currentPLSdir" == '' ]]; then currentPLSdir=$(echo "$line" | awk -v FS="/RetroPie/" '{print $2}' ); fi; fi
		done < /dev/shm/pls
	fi
	rm /dev/shm/pls
	httpBASE=$(echo $dirBASE$mp3BASE | tr -d '\' 2>/dev/null)
fi

if [[ ! "$streamNAME" == '' ]] && [[ "$streamURL" == '' ]]; then streamURL=$streamNAME; fi
if [[ ! "$streamURL" == '' ]]; then
	plistINFO="\Z0STREAM [\Z4$streamURL\Z0]  SHUFFLE [\Z4$shuffleMODE\Z0]  REPEAT [\Z4$infinite_mode\Z0]"
else
	plistINFO="\Z0TIME ELAPSED [\Z4$trackTIME\Z0]  SHUFFLE [\Z4$shuffleMODE\Z0]  REPEAT [\Z4$infinite_mode\Z0]"
fi

currentVOLUME="\Z0Volume [\Z4$volume_percent\Z0]"

currentPLIST=$(
echo
result=`pgrep mpg123`
if [[ "$result" == '' ]] && [[ "$(cat $IMPSettings/pause.flag)" == "0" ]]; then pausemode="\Z1STOPPED\Zn"; fi
echo "  [$pausemode] Track: \Zb\Z4$trackFILE\Zn"
if [[ ! "$trackALBUM" == '' ]] || [[ ! "$trackYEAR" == '' ]]; then echo "  $trackALBUM$trackYEAR"; fi
if [[ ! "$trackARTIST" == '' ]]; then echo "  $trackARTIST"; fi
if [[ ! "$trackTITLE" == '' ]] || [[ ! "$streamNAME" == '' ]]; then echo "  $trackTITLE$streamNAME"; fi
if [[ ! "$currentBASE" == '' ]]; then echo "  [\Zb\Z4$currentBASE\Zn]"; fi
if [[ ! "$currentPLS" == '' ]]; then echo "  [\Zb\Z4$currentPLSdir\Zn]"; fi
echo " -------------------"

while read line; do
	if [[ "$line" == "http"* ]]; then
		if [[ $line == *"$httpBASE"* ]]; then
			echo "\Zb\Z4><  $line  [SELECTED] \Zn"
		else
			echo "    $line"
		fi
	else
		currentLINE=$(echo "$line" | sed 's|.*/||'  )
		currentDIR=$(echo "$line" | rev | cut -d/ -f2 | rev )
		if [[ $line == *"$mp3BASE"* ]]; then
			echo "\Zb\Z4><  $currentLINE  [SELECTED] \Zn"
		else
			echo "    $currentLINE"
		fi
	fi
done < $currentLIST

if ! [[ "$streamTITLE" == '' ]]; then 
	echo
	echo "$streamTITLE"
	echo " -------------------"
else
	echo " -------------------"
fi
)

dialog --colors --no-collapse --title "  $currentVOLUME  $plistINFO" --msgbox "$currentPLIST"  0 0 &
echo
echo -n "9.."
sleep 1
echo -n "8.."
sleep 1
echo -n "7.."
sleep 1
echo -n "6.."
sleep 1
echo -n "5.."
sleep 1
echo -n "4.."
sleep 1
echo -n "3.."
sleep 1
echo -n "2.."
sleep 1
echo -n "1.."
sleep 1
echo -n ".."
tput reset
exit 0
