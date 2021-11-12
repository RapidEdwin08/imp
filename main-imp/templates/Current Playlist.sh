#!/bin/bash
tput reset
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# FULL MODE Write to Disk - LITE MODE Write to tmpfs - Recall Last Track/Position Lost on REBOOT using LITE MODE
if [ $(cat $IMPSettings/lite.flag) == "0" ]; then
	currentTRACK=$IMPPlaylist/current-track
	trackTIME=$(grep '>*+' /opt/retropie/configs/imp/playlist/current-track | tail -1 | sed -n -e 's/^.*> //p' |awk '{print $2}' | cut -d '.' -f 1)
else
	currentTRACK=/dev/shm/current-track
	trackTIME=$(grep '>*+' /dev/shm/current-track | tail -1 | sed -n -e 's/^.*> //p' |awk '{print $2}' | cut -d '.' -f 1)
fi

trackFILE=$(grep -iE 'Playing MPEG stream' $currentTRACK | cut -b 28-999 | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop' | perl -ple 'chop')
trackTITLE=$(grep -iE 'Title:' $currentTRACK)
trackALBUM=$(grep -iE 'Album:' $currentTRACK)
trackYEAR=$(grep -iE 'Year:' $currentTRACK)
playerVOL=$(cat $IMPSettings/volume.flag)
if [ $playerVOL == "32768" ]; then volume_percent="100"; fi
if [ $playerVOL == "29484" ]; then volume_percent="90"; fi
if [ $playerVOL == "26208" ]; then volume_percent="80"; fi
if [ $playerVOL == "22932" ]; then volume_percent="70"; fi
if [ $playerVOL == "19656" ]; then volume_percent="60"; fi
if [ $playerVOL == "16380" ]; then volume_percent="50"; fi
if [ $playerVOL == "13104" ]; then volume_percent="40"; fi
if [ $playerVOL == "9828" ]; then volume_percent="30"; fi
if [ $playerVOL == "6552" ]; then volume_percent="20"; fi
if [ $playerVOL == "3276" ]; then volume_percent="10"; fi
if [ $playerVOL == "1638" ]; then volume_percent="5"; fi

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

streamURL=$(grep -iE 'ICY-URL:' $currentTRACK | cut -b 10-999)
streamNAME=$(grep -iE 'ICY-NAME:' $currentTRACK | cut -b 11-999)
streamTITLE=$(grep -iE 'StreamTitle=' $currentTRACK | cut -b 23-999 | cut -d ';' -f 1 )
pausemode=$(cat $IMPSettings/pause.flag)
if [[ $pausemode == "1" || $pausemode == "2" ]]; then pausemode="PAUSED"; else pausemode="PLAYING"; fi

if [ $(cat $IMPSettings/shuffle.flag) == "1" ]; then
	currentLIST=$IMPPlaylist/shuffle
	shuffleMODE="ON"
else
	currentLIST=$IMPPlaylist/abc
	shuffleMODE="OFF"
fi

if ! [[ "$streamURL" == '' ]]; then
	plistINFO="[STREAMING: $streamURL]  [SHUFFLE Mode: $shuffleMODE]  "
else
	plistINFO="[TIME ELAPSED: $trackTIME]  [SHUFFLE Mode: $shuffleMODE]  "
fi

currentVOLUME="[Player Volume %$volume_percent]"

currentPLIST=$(
echo
echo
result=`pgrep mpg123`
if [[ "$result" == '' ]]; then pausemode="STOPPED"; fi
echo "  [$pausemode] Track: $trackFILE $trackALBUM $trackYEAR $streamURL"
if [ ! "$trackTITLE" == '' ] || [ ! "$streamNAME" == '' ]; then echo "  $trackTITLE $streamNAME"; fi
echo " -------------------"

while read line; do
	if [[ "$line" == "http"* ]]; then
		if [[ $line == *"$mp3BASE"* ]]; then
			echo "><  $line  [SELECTED] "
		else
			echo "    $line"
		fi
	else
		currentLINE=$(echo "$line" | sed 's|.*/||'  )
		currentDIR=$(echo "$line" | rev | cut -d/ -f2 | rev )
		if [[ $line == *"$mp3BASE"* ]]; then
			echo "><  ./$currentDIR/$currentLINE  [SELECTED] "
		else
			echo "    ./$currentDIR/$currentLINE"
		fi
	fi
done < $currentLIST

if ! [[ "$streamTITLE" == '' ]]; then 
	echo "$streamTITLE"
	echo " -------------------"
else
	echo " -------------------"
fi
)

dialog --no-collapse --title "  $currentVOLUME  $plistINFO" --msgbox "$currentPLIST"  0 0 &
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
