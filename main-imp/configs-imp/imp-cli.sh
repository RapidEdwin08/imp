#!/bin/bash
# 202611 IMP CLI

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
	S "~ Settings" \
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
	defaultITEM=C
	setMAINmenu
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

setMAINmenu()
{
sleep 0.2 # Refresh Status
clear

setMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	C "# Current Settings #                      " \
	S "General Settings              \Zb_-+-_                                " \
	B "BGM Settings                 \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	G "Game Settings           \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	H "HTTP Server Settings    \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	I "Idle Settings          \Zb.:;':--.-:-----::---:-                      " \
	R "Randomizer Settings   \Zb'::.   -.------   .-:                        " \
	U "Start-Up Settings      \Zb:-   ':------:. '::.                        " \
	- "                       \Zb=-'  .::-..-::-  ='                         " \
	- "                            \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	- "                            \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	- "                            \Zb'::-'..-'\Zn                             " \
	- "                             \Zb.:-:.'''\Zn       " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$setMENU" == '' ] || [ ! "$setMENU" == '-' ]; then
	defaultITEM=$setMENU
fi

if [ "$setMENU" == '-' ]; then
	defaultITEM=-
	setMAINmenu
fi

if [ "$setMENU" == 'C' ]; then
	bash $IMPrpMENU/Settings/Current\ Settings.sh
	setMAINmenu
fi

if [ "$setMENU" == 'S' ]; then
	defaultITEM=C
	GENsetMAINmenu
fi

if [ "$setMENU" == 'B' ]; then
	defaultITEM=C
	BGMsetMAINmenu
fi

if [ "$setMENU" == 'G' ]; then
	defaultITEM=C
	GAMEsetMAINmenu
fi

if [ "$setMENU" == 'H' ]; then
	defaultITEM=C
	HTTPsetMAINmenu
fi

if [ "$setMENU" == 'I' ]; then
	defaultITEM=C
	IDLEsetMAINmenu
fi

if [ "$setMENU" == 'R' ]; then
	defaultITEM=C
	RNDMsetMAINmenu
fi

if [ "$setMENU" == 'U' ]; then
	defaultITEM=C
	STARTsetMAINmenu
fi

if [ "$BGMsetMENU" == '' ]; then
	defaultITEM=S
else
	defaultITEM=$setMENU
fi
impMAINmenu
}

GENsetMAINmenu()
{
sleep 0.2 # Refresh Status
clear

GENsetMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	C "# Current Settings #                      " \
	0 "Fade Volume [0ff]             \Zb_-+-_                                " \
	1 "Fade Volume [x1]             \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	2 "Fade Volume [x5]        \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	3 "Fade Volume [x10]       \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	4 "IMP Lite [Off]         \Zb.:;':--.-:-----::---:-                      " \
	5 "IMP Lite [On]         \Zb'::.   -.------   .-:                        " \
	6 "Repeat Mode [Off]      \Zb:-   ':------:. '::.                        " \
	7 "Repeat Mode [1]        \Zb=-'  .::-..-::-  ='                         " \
	8 "Repeat Mode [ALL]           \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	- "                            \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	- "                            \Zb'::-'..-'\Zn                             " \
	- "                             \Zb.:-:.'''\Zn       " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$GENsetMENU" == '' ] || [ ! "$GENsetMENU" == '-' ]; then
	defaultITEM=$GENsetMENU
fi

if [ "$GENsetMENU" == '-' ]; then
	defaultITEM=-
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == 'C' ]; then
	bash $IMPrpMENU/Settings/Current\ Settings.sh
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == '0' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/Fade\ Volume\ \[0ff\].sh
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == '1' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/Fade\ Volume\ \[x1\].sh
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == '2' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/Fade\ Volume\ \[x5\].sh
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == '3' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/Fade\ Volume\ \[x10\].sh
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == '4' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/IMP\ Lite\ \[Off\].sh
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == '5' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/IMP\ Lite\ \[On\].sh
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == '6' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/Infinite\ IMP\ \[Off\].sh
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == '7' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/Infinite\ IMP\ \[On\].sh
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == '8' ]; then
	bash $IMPrpMENU/Settings/General\ Settings/Infinite\ IMP\ \[ALL\].sh
	GENsetMAINmenu
fi

if [ "$GENsetMENU" == '' ]; then
	defaultITEM=S
else
	defaultITEM=$GENsetMENU
fi
setMAINmenu
}

BGMsetMAINmenu()
{
sleep 0.2 # Refresh Status
clear

BGMsetMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	C "# Current Settings #                      " \
	1 "BGM A-Side [Off]              \Zb_-+-_                                " \
	2 "BGM A-Side [On]              \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	3 "BGM B-Side [Off]        \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	4 "BGM B-Side [On]         \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	5 "Play Quit Song [Off]   \Zb.:;':--.-:-----::---:-                      " \
	6 "Play Quit Song [On]   \Zb'::.   -.------   .-:                        " \
	7 "Startup Song [Off]     \Zb:-   ':------:. '::.                        " \
	8 "Startup Song [On]      \Zb=-'  .::-..-::-  ='                         " \
	- "                            \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	- "                            \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	- "                            \Zb'::-'..-'\Zn                             " \
	- "                             \Zb.:-:.'''\Zn       " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$BGMsetMENU" == '' ] || [ ! "$BGMsetMENU" == '-' ]; then
	defaultITEM=$BGMsetMENU
fi

if [ "$BGMsetMENU" == '-' ]; then
	defaultITEM=-
	BGMsetMAINmenu
fi

if [ "$BGMsetMENU" == 'C' ]; then
	bash $IMPrpMENU/Settings/Current\ Settings.sh
	BGMsetMAINmenu
fi

if [ "$BGMsetMENU" == '1' ]; then
	bash $IMPrpMENU/Settings/BGM\ Settings/BGM\ A-Side\ \[Off\].sh
	BGMsetMAINmenu
fi

if [ "$BGMsetMENU" == '2' ]; then
	bash $IMPrpMENU/Settings/BGM\ Settings/BGM\ A-Side\ \[On\].sh
	BGMsetMAINmenu
fi

if [ "$BGMsetMENU" == '3' ]; then
	bash $IMPrpMENU/Settings/BGM\ Settings/BGM\ B-Side\ \[Off\].sh
	BGMsetMAINmenu
fi

if [ "$BGMsetMENU" == '4' ]; then
	bash $IMPrpMENU/Settings/BGM\ Settings/BGM\ B-Side\ \[On\].sh
	BGMsetMAINmenu
fi

if [ "$BGMsetMENU" == '5' ]; then
	bash $IMPrpMENU/Settings/BGM\ Settings/Play\ Quit\ Song\ \[Off\].sh
	BGMsetMAINmenu
fi

if [ "$BGMsetMENU" == '6' ]; then
	bash $IMPrpMENU/Settings/BGM\ Settings/Play\ Quit\ Song\ \[On\].sh
	BGMsetMAINmenu
fi

if [ "$BGMsetMENU" == '7' ]; then
	bash $IMPrpMENU/Settings/BGM\ Settings/Play\ Startup\ Song\ \[Off\].sh
	BGMsetMAINmenu
fi

if [ "$BGMsetMENU" == '8' ]; then
	bash $IMPrpMENU/Settings/BGM\ Settings/Play\ Startup\ Song\ \[On\].sh
	BGMsetMAINmenu
fi

if [ "$BGMsetMENU" == '' ]; then
	defaultITEM=B
else
	defaultITEM=$BGMsetMENU
fi
setMAINmenu
}

GAMEsetMAINmenu()
{
sleep 0.2 # Refresh Status
clear

GAMEsetMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	C "# Current Settings #                      " \
	1 "[00] Delay @Game End         \Zb_-+-_                                " \
	2 "[05] Delay @Game End        \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	3 "[10] Delay @Game End   \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	4 "[15] Delay @Game End   \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	5 "[20] Delay @Game End  \Zb.:;':--.-:-----::---:-                      " \
	6 "[25] Delay @Game End \Zb'::.   -.------   .-:                        " \
	7 "[30] Delay @Game End  \Zb:-   ':------:. '::.                        " \
	8 "Music 0ver Games[Off] \Zb=-'  .::-..-::-  ='                         " \
	9 "Music 0ver Games[On]       \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	10 "Music Idle 0ver Games[On]  \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	- "                           \Zb'::-'..-'\Zn                             " \
	- "                            \Zb.:-:.'''\Zn       " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$GAMEsetMENU" == '' ] || [ ! "$GAMEsetMENU" == '-' ]; then
	defaultITEM=$GAMEsetMENU
fi

if [ "$GAMEsetMENU" == '-' ]; then
	defaultITEM=-
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == 'C' ]; then
	bash $IMPrpMENU/Settings/Current\ Settings.sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '1' ]; then
	bash $IMPrpMENU/Settings/Game\ Settings/\[00\]\ Delay\ At\ Game\ End.sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '2' ]; then
	bash $IMPrpMENU/Settings/Game\ Settings/\[05\]\ Delay\ At\ Game\ End.sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '3' ]; then
	bash $IMPrpMENU/Settings/Game\ Settings/\[10\]\ Delay\ At\ Game\ End.sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '4' ]; then
	bash $IMPrpMENU/Settings/Game\ Settings/\[15\]\ Delay\ At\ Game\ End.sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '5' ]; then
	bash $IMPrpMENU/Settings/Game\ Settings/\[20\]\ Delay\ At\ Game\ End.sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '6' ]; then
	bash $IMPrpMENU/Settings/Game\ Settings/\[25\]\ Delay\ At\ Game\ End.sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '7' ]; then
	bash $IMPrpMENU/Settings/Game\ Settings/\[30\]\ Delay\ At\ Game\ End.sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '8' ]; then
	bash $IMPrpMENU/Settings/Game\ Settings/Music\ 0ver\ Games\ \[Off\].sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '9' ]; then
	bash $IMPrpMENU/Settings/Game\ Settings/Music\ 0ver\ Games\ \[On\].sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '10' ]; then
	bash $IMPrpMENU/Settings/Game\ Settings/Music\ Idle\ 0ver\ Games\ \[On\].sh
	GAMEsetMAINmenu
fi

if [ "$GAMEsetMENU" == '' ]; then
	defaultITEM=G
else
	defaultITEM=$GAMEsetMENU
fi
setMAINmenu
}

HTTPsetMAINmenu()
{
sleep 0.2 # Refresh Status
clear

HTTPsetMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	C "# Current Settings #                      " \
	1 "HTTP Server Log               \Zb_-+-_                                " \
	2 "HTTP Server Music [On]       \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	3 "HTTP Server Roms [On]   \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	4 "HTTP Server [Off]       \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	- "                       \Zb.:;':--.-:-----::---:-                      " \
	- "                      \Zb'::.   -.------   .-:                        " \
	- "                       \Zb:-   ':------:. '::.                        " \
	- "                       \Zb=-'  .::-..-::-  ='                         " \
	- "                            \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	- "                            \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	- "                            \Zb'::-'..-'\Zn                             " \
	- "                             \Zb.:-:.'''\Zn       " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$HTTPsetMENU" == '' ] || [ ! "$HTTPsetMENU" == '-' ]; then
	defaultITEM=$HTTPsetMENU
fi

if [ "$HTTPsetMENU" == '-' ]; then
	defaultITEM=-
	HTTPsetMAINmenu
fi

if [ "$HTTPsetMENU" == 'C' ]; then
	bash $IMPrpMENU/Settings/Current\ Settings.sh
	HTTPsetMAINmenu
fi

if [ "$HTTPsetMENU" == '1' ]; then
	bash $IMPrpMENU/Settings/HTTP\ Server\ Settings/HTTP\ Server\ Log.sh
	HTTPsetMAINmenu
fi

if [ "$HTTPsetMENU" == '2' ]; then
	bash $IMPrpMENU/Settings/HTTP\ Server\ Settings/HTTP\ Server\ Music\ \[On\].sh
	HTTPsetMAINmenu
fi

if [ "$HTTPsetMENU" == '3' ]; then
	bash $IMPrpMENU/Settings/HTTP\ Server\ Settings/HTTP\ Server\ Roms\ \[On\].sh
	HTTPsetMAINmenu
fi

if [ "$HTTPsetMENU" == '4' ]; then
	bash $IMPrpMENU/Settings/HTTP\ Server\ Settings/HTTP\ Server\ \[Off\].sh
	HTTPsetMAINmenu
fi

if [ "$HTTPsetMENU" == '' ]; then
	defaultITEM=H
else
	defaultITEM=$HTTPsetMENU
fi
setMAINmenu
}

IDLEsetMAINmenu()
{
sleep 0.2 # Refresh Status
clear

IDLEsetMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	C "# Current Settings #                      " \
	X "Idle @Screensaver [0ff]       \Zb_-+-_                                " \
	V "Idle @Screensaver [Video]    \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	A "Idle @Screensaver [Any] \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	S "Idle Behavior [Stop]    \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	L "Idle Behavior [Volume] \Zb.:;':--.-:-----::---:-                      " \
	D "Stop IMP @Sleep [0ff] \Zb'::.   -.------   .-:                        " \
	P "Stop IMP @Sleep [0n]   \Zb:-   ':------:. '::.                        " \
	K "KillDisplay @Sleep[0n] \Zb=-'  .::-..-::-  ='                         " \
	0 "%05 Idle IMP Volume         \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	1 "%10 Idle IMP Volume         \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	2 "%20 Idle IMP Volume         \Zb'::-'..-'\Zn                             " \
	3 "%30 Idle IMP Volume          \Zb.:-:.'''\Zn                             " \
	4 "%40 Idle IMP Volume                                      " \
	5 "%50 Idle IMP Volume                                      " \
	6 "%60 Idle IMP Volume                                      " \
	7 "%70 Idle IMP Volume                                      " \
	8 "%80 Idle IMP Volume                                      " \
	9 "%90 Idle IMP Volume                                      " \
	M "[MAX] Idle IMP Volume               " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$IDLEsetMENU" == '' ] || [ ! "$IDLEsetMENU" == '-' ]; then
	defaultITEM=$IDLEsetMENU
fi

if [ "$IDLEsetMENU" == '-' ]; then
	defaultITEM=-
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == 'C' ]; then
	bash $IMPrpMENU/Settings/Current\ Settings.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == 'X' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/Idle\ at\ Screensaver\ \[0ff\].sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == 'V' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/Idle\ at\ Screensaver\ \[Video\]\ \[0n\].sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == 'A' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/Idle\ at\ Screensaver\ \[Any\]\ \[0n\].sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == 'S' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/Idle\ IMP\ Behavior\ \[Stop\].sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == 'L' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/Idle\ IMP\ Behavior\ \[Volume\].sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == 'D' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/Stop\ IMP\ at\ Sleep\ \[0ff\].sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == 'P' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/Stop\ IMP\ Sleep\ \[0n\].sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == 'K' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/Stop+Kill\ Display\ at\ Sleep\ \[0n\].sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '0' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[05\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '1' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[10\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '2' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[20\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '3' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[30\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '4' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[40\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '5' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[50\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '6' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[60\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '7' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[70\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '8' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[80\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '9' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[90\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == 'M' ]; then
	bash $IMPrpMENU/Settings/Idle\ Settings/\[MAX\]\ Idle\ IMP\ Volume.sh
	IDLEsetMAINmenu
fi

if [ "$IDLEsetMENU" == '' ]; then
	defaultITEM=I
else
	defaultITEM=$IDLEsetMENU
fi
setMAINmenu
}

RNDMsetMAINmenu()
{
sleep 0.2 # Refresh Status
clear

RNDMsetMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	C "# Current Settings #                      " \
	0 "Randomizer [Off]              \Zb_-+-_                                " \
	1 "Randomizer [On]              \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	2 "Randomizer Mode [ALL]   \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	3 "Randomizer Mode [BGM]   \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	4 "Randomizer Mode [PLS]  \Zb.:;':--.-:-----::---:-                      " \
	- "                      \Zb'::.   -.------   .-:                        " \
	- "                       \Zb:-   ':------:. '::.                        " \
	- "                       \Zb=-'  .::-..-::-  ='                         " \
	- "                            \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	- "                            \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	- "                            \Zb'::-'..-'\Zn                             " \
	- "                             \Zb.:-:.'''\Zn       " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$RNDMsetMENU" == '' ] || [ ! "$RNDMsetMENU" == '-' ]; then
	defaultITEM=$RNDMsetMENU
fi

if [ "$RNDMsetMENU" == '-' ]; then
	defaultITEM=-
	RNDMsetMAINmenu
fi

if [ "$RNDMsetMENU" == 'C' ]; then
	bash $IMPrpMENU/Settings/Current\ Settings.sh
	RNDMsetMAINmenu
fi

if [ "$RNDMsetMENU" == '0' ]; then
	bash $IMPrpMENU/Settings/Randomizer\ Settings/Music\ Randomizer\ \[Off\].sh
	RNDMsetMAINmenu
fi

if [ "$RNDMsetMENU" == '1' ]; then
	bash $IMPrpMENU/Settings/Randomizer\ Settings/Music\ Randomizer\ \[On\].sh
	RNDMsetMAINmenu
fi

if [ "$RNDMsetMENU" == '2' ]; then
	bash $IMPrpMENU/Settings/Randomizer\ Settings/Randomizer\ Mode\ \[ALL\].sh
	RNDMsetMAINmenu
fi

if [ "$RNDMsetMENU" == '3' ]; then
	bash $IMPrpMENU/Settings/Randomizer\ Settings/Randomizer\ Mode\ \[BGM\].sh
	RNDMsetMAINmenu
fi

if [ "$RNDMsetMENU" == '4' ]; then
	bash $IMPrpMENU/Settings/Randomizer\ Settings/Randomizer\ Mode\ \[PLS\].sh
	RNDMsetMAINmenu
fi

if [ "$RNDMsetMENU" == '' ]; then
	defaultITEM=R
else
	defaultITEM=$RNDMsetMENU
fi
setMAINmenu
}

STARTsetMAINmenu()
{
sleep 0.2 # Refresh Status
clear

STARTsetMENU=$(dialog --colors --no-collapse --default-item "$defaultITEM" --title "\Z0${currentMUSICdir}\Zn" \
	--ok-label " SELECT " --cancel-label BACK \
	--menu "             \Zn\Z1I\Znntegrated \Z1M\Znusic \Z1P\Znlayer for \Z1R\Znetro\Z1P\Znie \Z1v\Zn$versionIMP" 25 75 20 \
	C "# Current Settings #                      " \
	N "Music @Startup [Off]          \Zb_-+-_                                " \
	Y "Music @Startup [On]          \Zb'#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                               " \
	X "Shuffle Playlist [Off]  \Zb\Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb                         " \
	S "Shuffle Playlist [On]   \Zb'-+++#::\Zb\Z7_\Zn\Zb::#+++-''                         " \
	0 "[000] Delay @Startup   \Zb.:;':--.-:-----::---:-                      " \
	1 "[005] Delay @Startup  \Zb'::.   -.------   .-:                        " \
	2 "[010] Delay @Startup   \Zb:-   ':------:. '::.                        " \
	3 "[015] Delay @Startup   \Zb=-'  .::-..-::-  ='                         " \
	4 "[020] Delay @Startup        \Zb.::-.'-\Zb\Z7^\Zn\Zb--\Zn                             " \
	5 "[025] Delay @Startup        \Zb'-\Z7^\Zn\Zb-. .-:'\Zn                             " \
	6 "[030] Delay @Startup        \Zb'::-'..-'\Zn                             " \
	7 "[030] Delay @Startup         \Zb.:-:.'''\Zn                             " \
	8 "[035] Delay @Startup                                     " \
	9 "[040] Delay @Startup                                     " \
	A "[045] Delay @Startup                                     " \
	B "[055] Delay @Startup                                     " \
	C "[060] Delay @Startup                                     " \
	D "[070] Delay @Startup                                     " \
	E "[080] Delay @Startup                                     " \
	F "[090] Delay @Startup                                     " \
	G "[100] Delay @Startup                                     " \
	H "[110] Delay @Startup                                     " \
	I "[120] Delay @Startup                " 2>&1>/dev/tty)

# Confirmed - Otherwise Back to Main Menu
if [ ! "$STARTsetMENU" == '' ] || [ ! "$STARTsetMENU" == '-' ]; then
	defaultITEM=$STARTsetMENU
fi

if [ "$STARTsetMENU" == '-' ]; then
	defaultITEM=-
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'C' ]; then
	bash $IMPrpMENU/Settings/Current\ Settings.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'N' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/Music\ At\ Startup\ \[Off\].sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'Y' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/Music\ At\ Startup\ \[On\].sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'X' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/Shuffle\ Playlist\ \[Off\].sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'S' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/Shuffle\ Playlist\ \[On\].sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '0' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[000\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '1' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[005\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '2' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[010\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '3' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[015\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '4' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[020\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '5' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[025\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '6' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[030\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '7' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[035\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '8' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[040\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '9' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[045\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'A' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[050\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'B' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[055\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'C' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[060\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'D' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[070\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'E' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[080\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'F' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[090\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'G' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[100\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'H' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[110\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == 'I' ]; then
	bash $IMPrpMENU/Settings/Startup\ Settings/\[120\]\ Delay\ At\ Startup.sh
	STARTsetMAINmenu
fi

if [ "$STARTsetMENU" == '' ]; then
	defaultITEM=U
else
	defaultITEM=$STARTsetMENU
fi
setMAINmenu
}

impMAINmenu

#read -p " ..." </dev/tty
tput reset
exit 0
