#!/bin/bash
# Check for [IMP] Files/Folders Linked to [retropiemenu] [gamelist.xml]
# Create Files/Folders If Needed to Prevent ERROR Loading emulationstation:
# ~/RetroPie-Setup/tmp/build/emulationstation/es-app/src/FileData.cpp:218: void FileData::addChild(FileData*): Assertion `mType == FOLDER' failed.
# Scenario where ES may Fail to Load is IF [parse XML gamelist only] is "OFF" + there are NO MP3s in the Dedicated Music Folders

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

# Put something in [musicDIR] If No MP3s found at all
for d in $(find $musicDIR -type d | grep -v $BGMa | grep -v $BGMb); do find $d -iname *.mp3 >> /dev/shm/tmpMP3; done
if [[ $(cat /dev/shm/tmpMP3) == '' ]]; then cp ~/RetroPie/retropiemenu/icons/impstartallm0.png "$musicDIR/MMMenu.mp3" > /dev/null 2>&1; fi
rm /dev/shm/tmpMP3 > /dev/null 2>&1

# Put something in [BGMadir] If No MP3s found
mp3BGMa=$(find $BGMa -iname *.mp3 )
if [[ "$mp3BGMa" == '' ]]; then cp ~/RetroPie/retropiemenu/icons/impstartbgmm0a.png "$musicDIR/bgm/A-SIDE/e1m1.mp3" > /dev/null 2>&1; fi

# Put something in [BGMbdir] If No MP3s found
mp3BGMb=$(find $BGMb -iname *.mp3 )
if [[ "$mp3BGMb" == '' ]]; then cp ~/RetroPie/retropiemenu/icons/impstartbgmm0b.png "$musicDIR/bgm/B-SIDE/e1m2.mp3" > /dev/null 2>&1; fi

#tput reset
exit 0
