#!/bin/bash
# 202512 IMP CLI

IMP=/opt/retropie/configs/imp
#IMPrpMENU=~/RetroPie/retropiemenu/imp # Do not rely on default retropiemenu location
IMPrpMENU=$IMP/retropiemenu
versionIMP=$(cat $IMP/VERSION)
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
musicDIR=~/RetroPie/retropiemenu/imp/music
defaultITEM=-

impMAINmenu()
{
sleep 0.7 # Refresh Status
clear
currentMUSICdir=$musicDIR
pausemode=$(cat $IMPSettings/pause.flag)
if [[ $pausemode == "1" || $pausemode == "2" ]]; then pausemode="\Z3\ZbPAUSED\Zn"; else pausemode="\Z2PLAYING\Zn"; fi
result=`pgrep mpg123`
if [[ "$result" == '' ]] && [[ "$(cat $IMPSettings/pause.flag)" == "0" ]]; then pausemode="\Z1STOPPED\Zn"; fi

impMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label QUIT \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	P "# Current Playlist #                      \Z4Status:\Zn[$pausemode]" \
	1 "./Music                      \Zb_-+-_                                " \
	2 "<] Previous List            \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	3 "<< Previous Track      \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	4 "<> Play                \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	5 "== Pause              \Zb.:;':--.-:-----::---:-                      " \
	6 ">< Stop              \Zb'::.   -.------   .-:                        " \
	7 ">> Next Track         \Zb:-   ':------:. '::.                        " \
	8 ">] Next List          \Zb=-'  .::-..-::-  ='                         " \
	9 "{} Shuffle OFF             \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	10 "}{ Shuffle ON              \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	11 "<> Start [ALL] Music       \Zb'::-'..-'\Zn                             " \
	12 "<> Start [BGM] Music        \Zb.:-:.'''\Zn       " \
	13 "<> Start Randomizer" \
	14 "~ Randomizer [Mode]" \
	15 "~ Repeat [Mode]" \
	S "# Current Settings #" \
	V "^ {Volume}" 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$impMENU" == '' ] || [ ! "$impMENU" == '-' ]; then
	defaultITEM=$impMENU
fi

if [ "$impMENU" == 'P' ]; then
	bash $IMPrpMENU/Current\ Playlist.sh
	impMAINmenu
fi

if [ "$impMENU" == '1' ]; then
	impMUSICmenu
fi

if [ "$impMENU" == '2' ]; then
	bash "$IMP/previousalbum.sh" > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '3' ]; then
	bash $IMP/previous.sh > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '4' ]; then
	bash $IMP/play.sh > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '5' ]; then
	bash $IMPrpMENU/Pause.sh > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '6' ]; then
	bash $IMP/stop.sh > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '7' ]; then
	bash $IMPrpMENU/Next\ Track.sh > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '8' ]; then
	# Respect Repeat Mode [1] if NOT called by menu
	bash "$IMP/nextalbum.sh" repeat1 > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '9' ]; then
	bash $IMPrpMENU/Shuffle\ Off.sh > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '10' ]; then
	bash $IMPrpMENU/Shuffle\ On.sh > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '11' ]; then
	bash $IMPrpMENU/Start\ All\ Music.sh > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '12' ]; then
	bash $IMPrpMENU/Start\ BGM\ Music.sh > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '13' ]; then
	bash $IMPrpMENU/Start\ Randomizer.sh > /dev/null 2>&1
	impMAINmenu
fi

if [ "$impMENU" == '14' ]; then
	randomMAINmenu
fi

if [ "$impMENU" == '15' ]; then
	repMAINmenu
fi

if [ "$impMENU" == 'S' ]; then
	bash $IMPrpMENU/Settings/Current\ Settings.sh
	impMAINmenu
fi

if [ "$impMENU" == 'V' ]; then
	volMAINmenu
fi

if [ "$impMENU" == 'Q' ] || [ "$impMENU" == '' ]; then
	tput reset
	sysinfo
	exit 0
fi

impMAINmenu
}

volMAINmenu()
{
sleep 0.2 # Refresh Status
clear
playerVOL=$(cat $IMPSettings/volume.flag)
if [ $playerVOL == "32768" ]; then volume_percent="\Z1%100\Zn"; fi
if [ $playerVOL == "29484" ]; then volume_percent="\Z1%90\Zn"; fi
if [ $playerVOL == "26208" ]; then volume_percent="\Z3\Zb%80\Zn"; fi
if [ $playerVOL == "22932" ]; then volume_percent="\Z3\Zb%70\Zn"; fi
if [ $playerVOL == "19656" ]; then volume_percent="\Z2%60\Zn"; fi
if [ $playerVOL == "16380" ]; then volume_percent="\Z2%50\Zn"; fi
if [ $playerVOL == "13104" ]; then volume_percent="\Z2%40\Zn"; fi
if [ $playerVOL == "9828" ]; then volume_percent="\Zb%30\Zn"; fi
if [ $playerVOL == "6552" ]; then volume_percent="\Zb%20\Zn"; fi
if [ $playerVOL == "3276" ]; then volume_percent="\Zb%10\Zn"; fi
if [ $playerVOL == "1638" ]; then volume_percent="\Zb%5\Zn"; fi
if [ $playerVOL == "0000" ]; then volume_percent="\Z1MUTE\Zn"; fi

volMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	P "## Playlist                               \Z4Volume:\Zn[$volume_percent]" \
	0 "[05] Player Volume           \Zb_-+-_                                " \
	1 "[10] Player Volume          \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	2 "[20] Player Volume     \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	3 "[30] Player Volume     \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	4 "[40] Player Volume    \Zb.:;':--.-:-----::---:-                      " \
	5 "[50] Player Volume   \Zb'::.   -.------   .-:                        " \
	6 "[60] Player Volume    \Zb:-   ':------:. '::.                        " \
	7 "[70] Player Volume    \Zb=-'  .::-..-::-  ='                         " \
	8 "[80] Player Volume         \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	9 "[90] Player Volume         \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	10 "[MAX] Player Volume        \Zb'::-'..-'\Zn                             " \
	 M "{MUTE}                      \Zb.:-:.'''\Zn       " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$volMENU" == '' ] || [ ! "$volMENU" == '-' ]; then
	defaultITEM=$volMENU
fi

if [ "$volMENU" == '-' ]; then
	defaultITEM=-
	volMAINmenu
fi

if [ "$volMENU" == 'P' ]; then
	bash $IMPrpMENU/Current\ Playlist.sh
	volMAINmenu
fi

if [ "$volMENU" == '0' ]; then
	bash $IMPrpMENU/Volume/\[05\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == '1' ]; then
	bash $IMPrpMENU/Volume/\[10\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == '2' ]; then
	bash $IMPrpMENU/Volume/\[20\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == '3' ]; then
	bash $IMPrpMENU/Volume/\[30\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == '4' ]; then
	bash $IMPrpMENU/Volume/\[40\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == '5' ]; then
	bash $IMPrpMENU/Volume/\[50\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == '6' ]; then
	bash $IMPrpMENU/Volume/\[60\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == '7' ]; then
	bash $IMPrpMENU/Volume/\[70\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == '8' ]; then
	bash $IMPrpMENU/Volume/\[80\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == '9' ]; then
	bash $IMPrpMENU/Volume/\[90\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == '10' ]; then
	bash $IMPrpMENU/Volume/\[MAX\]\ Player\ Volume.sh
	volMAINmenu
fi

if [ "$volMENU" == 'M' ]; then
	bash $IMPrpMENU/Volume/\[00\]\ Player\ Volume.sh
	volMAINmenu
fi

defaultITEM=$impMENU
impMAINmenu
}

repMAINmenu()
{
clear
infinite_mode=$(cat $IMPSettings/infinite.flag)
if [ $infinite_mode == "0" ]; then infinite_mode="\Z1"OFF"\Zn"; fi
if [ $infinite_mode == "1" ]; then infinite_mode="\Z2 1 \Zn"; fi
if [[ $infinite_mode == "2" ]]; then infinite_mode="\Z2ALL\Zn"; fi

repMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	P "## Playlist                                \Z4Repeat:\Zn[$infinite_mode]" \
	1 " Repeat [ 1 ]                 \Zb_-+-_                                " \
	2 " Repeat [ALL]                \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	3 " Repeat [OFF]           \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	- "                        \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	- "                       \Zb.:;':--.-:-----::---:-                      " \
	- "                      \Zb'::.   -.------   .-:                        " \
	- "                       \Zb:-   ':------:. '::.                        " \
	- "                       \Zb=-'  .::-..-::-  ='                         " \
	- "                            \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	- "                            \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	- "                            \Zb'::-'..-'\Zn                             " \
	- "                             \Zb.:-:.'''\Zn       " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$repMENU" == '' ] || [ ! "$repMENU" == '-' ]; then
	defaultITEM=$repMENU
fi

if [ "$repMENU" == '-' ]; then
	defaultITEM=-
	repMAINmenu
fi

if [ "$repMENU" == 'P' ]; then
	bash $IMPrpMENU/Current\ Playlist.sh
	repMAINmenu
fi

if [ "$repMENU" == '1' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/Infinite\ IMP\ \[On\].sh
	repMAINmenu
fi

if [ "$repMENU" == '2' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/Infinite\ IMP\ \[ALL\].sh
	repMAINmenu
fi

if [ "$repMENU" == '3' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/Infinite\ IMP\ \[Off\].sh
	repMAINmenu
fi

defaultITEM=$impMENU
impMAINmenu
}

randomMAINmenu()
{
clear
randomizer_boot=$(cat $IMPSettings/randomizerboot.flag)
randomizer_mode=$(cat $IMPSettings/randomizer.flag)
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "0" ]; then randomizer_mode="\Z1ALL\Zn"; fi
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "0" ]; then randomizer_mode="\Z1ALL\Zn"; fi
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "1" ]; then randomizer_mode="\Z1ALL\Zn"; fi
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "2" ]; then randomizer_mode="\Z1BGM\Zn"; fi
if [ $randomizer_boot == "0" ] &&  [ $randomizer_mode == "3" ]; then randomizer_mode="\Z1PLS\Zn"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "0" ]; then randomizer_mode="\Z2ALL\Zn"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "1" ]; then randomizer_mode="\Z2ALL\Zn"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "2" ]; then randomizer_mode="\Z2BGM\Zn"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "3" ]; then randomizer_mode="\Z2PLS\Zn"; fi

randomMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	P "## Playlist                                \Z4Randomizer:\Zn[$randomizer_mode]" \
	1 " Randomizer [ALL]             \Zb_-+-_                                " \
	2 " Randomizer [BGM]            \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	3 " Randomizer [PLS]       \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	- "                        \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	- "                       \Zb.:;':--.-:-----::---:-                      " \
	- "                      \Zb'::.   -.------   .-:                        " \
	- "                       \Zb:-   ':------:. '::.                        " \
	- "                       \Zb=-'  .::-..-::-  ='                         " \
	- "                            \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	- "                            \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	- "                            \Zb'::-'..-'\Zn                             " \
	- "                             \Zb.:-:.'''\Zn       " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$randomMENU" == '' ] || [ ! "$randomMENU" == '-' ]; then
	defaultITEM=$randomMENU
fi

if [ "$randomMENU" == '-' ]; then
	defaultITEM=-
	randomMAINmenu
fi

if [ "$randomMENU" == 'P' ]; then
	bash $IMPrpMENU/Current\ Playlist.sh
	randomMAINmenu
fi

if [ "$randomMENU" == '1' ]; then
	bash $IMPrpMENU/Settings/Randomizer\ Settings/Randomizer\ Mode\ \[ALL\].sh
	randomMAINmenu
fi

if [ "$randomMENU" == '2' ]; then
	bash $IMPrpMENU/Settings/Randomizer\ Settings/Randomizer\ Mode\ \[BGM\].sh
	randomMAINmenu
fi

if [ "$randomMENU" == '3' ]; then
	bash $IMPrpMENU/Settings/Randomizer\ Settings/Randomizer\ Mode\ \[PLS\].sh
	randomMAINmenu
fi

defaultITEM=$impMENU
impMAINmenu
}


impMUSICmenu()
{
clear
# =====================================
if [[ "$defaultITEM" == '' ]]; then defaultITEM=0; fi

# Back to Menu IF musicDIR NOT FOUND
if [[ ! -d "$musicDIR" ]]; then
	dialog --no-collapse --title "  [$musicDIR] NOT FOUND   " --ok-label CONTINUE --msgbox "    IS MUSIC INSTALLED?... \n"  25 75
	impMAINmenu
fi

# Check if NO Files/Folders
if [ "$(ls -a -1 "${currentMUSICdir}" | awk 'NR>2' )" == '' ]; then
	dialog --no-collapse --title "  NO FILES FOUND   " --ok-label CONTINUE --msgbox "$currentMUSICdir [Avail $(df -h "${currentMUSICdir}" |awk '{print $4}' | grep -v Avail )]"  25 75
	if [[ "${currentMUSICdir}" == "$musicDIR" ]] || [[ "${currentMUSICdir}" == '/' ]]; then
		impMAINmenu
	else
		# Go up a Directory
		currentMUSICdir=$(dirname "${currentMUSICdir}")
		impMUSICmenu
	fi
fi

let i=0 # define counting variable
W=() # define working array
while read -r line; do # process file by file
    let i=$i+1
    W+=($i "$line")
done < <( ls -a -1 "${currentMUSICdir}" | awk 'NR>2' )
FILE=$(dialog --colors --default-item "$defaultITEM" --title "${currentMUSICdir}" --ok-label " SELECT " --cancel-label BACK --menu "Make a Selection from [\Z1$(basename "${currentMUSICdir}")\Zn]" 25 75 20 "${W[@]}" 3>&2 2>&1 1>&3  </dev/tty > /dev/tty) # show dialog and store output
#clear
#if [ $? -eq 0 ]; then # Exit with OK
if [ ! "$FILE" == '' ]; then
	defaultITEM=$FILE
	selectFILE=$(ls -a -1 "${currentMUSICdir}" | awk 'NR>2' | sed -n "`echo "$FILE p" | sed 's/ //'`")
	# Change to Sub-Directory IF NOT a FILE
	if [ -d "$currentMUSICdir/$selectFILE" ]; then
		currentMUSICdir="$currentMUSICdir/$selectFILE"
		defaultITEM=0
		impMUSICmenu
	# MP3
	elif [[ "$selectFILE" == *".mp3" ]] || [[ "$selectFILE" == *".MP3" ]] || [[ "$selectFILE" == *".Mp3" ]] || [[ "$selectFILE" == *".mP3" ]]; then
		bash "$IMP/rom.sh" "$currentMUSICdir/$selectFILE" &
		impMUSICmenu
	# PLS Option to PLAY or VIEW Playlists
	elif [[ "$selectFILE" == *".pls" ]] || [[ "$selectFILE" == *".PLS" ]] || [[ "$selectFILE" == *".PLs" ]] || [[ "$selectFILE" == *".Pls" ]] || [[ "$selectFILE" == *".plS" ]] || [[ "$selectFILE" == *".pLS" ]]; then
		readIMPfile=$(dialog --colors --no-collapse --title "\Z0? PLAY or VIEW Playlist File: [\Z1$selectFILE\Z0] ?\Zn" \
		--ok-label " SELECT " --cancel-label BACK \
		--menu "$currentMUSICdir/$selectFILE" 25 75 20 \
		1 "  PLAY [$selectFILE]  " \
		2 "  VIEW [$selectFILE]  " 2>&1>/dev/tty)
		
		if [ "$readIMPfile" == '2' ]; then
			readTEXT=$(cat "$currentMUSICdir/$selectFILE")
			dialog --no-collapse --title "  [$selectFILE]   " --ok-label CONTINUE --msgbox "$readTEXT"  25 75
			impMUSICmenu
		elif [ "$readIMPfile" == '1' ]; then
			bash "$IMP/rom.sh" "$currentMUSICdir/$selectFILE" &
			impMUSICmenu
		else
			impMUSICmenu
		fi
	# M3U Option to PLAY or VIEW Playlists
	elif [[ "$selectFILE" == *".m3u" ]] || [[ "$selectFILE" == *".M3U" ]] || [[ "$selectFILE" == *".M3u" ]] || [[ "$selectFILE" == *".m3U" ]]; then
		readIMPfile=$(dialog --colors --no-collapse --title "\Z0? PLAY or VIEW Playlist File: [\Z1$selectFILE\Z0] ?\Zn" \
		--ok-label " SELECT " --cancel-label BACK \
		--menu "$currentMUSICdir/$selectFILE" 25 75 20 \
		1 "  PLAY [$selectFILE]  " \
		2 "  VIEW [$selectFILE]  " 2>&1>/dev/tty)
		
		if [ "$readIMPfile" == '2' ]; then
			readTEXT=$(cat "$currentMUSICdir/$selectFILE")
			dialog --no-collapse --title "  [$selectFILE]   " --ok-label CONTINUE --msgbox "$readTEXT"  25 75
			impMUSICmenu
		elif [ "$readIMPfile" == '1' ]; then
			bash "$IMP/rom.sh" "$currentMUSICdir/$selectFILE" &
			clear
			impMUSICmenu
		else
			impMUSICmenu
		fi
	else
		# ??? Option to PLAY or VIEW Unknown File types
		readIMPfile=$(dialog --colors --no-collapse --title "\Z0? Attempt to PLAY or VIEW: [\Z1$selectFILE\Z0] ?\Zn" \
		--ok-label " SELECT " --cancel-label BACK \
		--menu " [$currentMUSICdir/$selectFILE] " 25 75 20 \
		1 "  PLAY [$selectFILE]  " \
		2 "  VIEW [$selectFILE]  " 2>&1>/dev/tty)
		
		if [ "$readIMPfile" == '2' ]; then
			readTEXT=$(cat "$currentMUSICdir/$selectFILE")
			dialog --no-collapse --title "  [$selectFILE]   " --ok-label CONTINUE --msgbox "$readTEXT"  25 75
			impMUSICmenu
		elif [ "$readIMPfile" == '1' ]; then
			bash "$IMP/rom.sh" "$currentMUSICdir/$selectFILE" &
			clear
			impMUSICmenu
		else
			impMUSICmenu
		fi
	fi
	# Check if NO Files/Folders
	if [ "$(ls -a -1 "${currentMUSICdir}" | awk 'NR>2' )" == '' ]; then
		dialog --no-collapse --title "  NO FILES FOUND   " --ok-label CONTINUE --msgbox "$currentMUSICdir [Avail $(df -h $currentMUSICdir |awk '{print $4}' | grep -v Avail )]"  25 75
		# Back to Menu IF in MAIN DIR
		if [ $currentMUSICdir == $musicDIR ]; then
			impMAINmenu
		else
			# Go up a Directory
			currentMUSICdir=$(dirname $currentMUSICdir)
			impMUSICmenu
		fi
	fi
	impMUSICmenu
fi

# Go up Directory IF NO INPUT + NOT MAIN DIRs
# Go up Directory Minus selectFILE
defaultITEM=0
if [[ ! "${currentMUSICdir}" == "$musicDIR" ]] && [[ ! "${currentMUSICdir}" == '/' ]]; then
	currentMUSICdir="$(dirname "${currentMUSICdir}")"
	impMUSICmenu
fi

impMAINmenu
}

impMAINmenu

#read -p " ..." </dev/tty
tput reset
exit 0
