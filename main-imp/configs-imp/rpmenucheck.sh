#!/bin/bash
# Check for [IMP] Files/Folders Linked to [retropiemenu] [gamelist.xml]
# Create Files/Folders If Needed to Prevent ERROR Loading emulationstation:
# ~/RetroPie-Setup/tmp/build/emulationstation/es-app/src/FileData.cpp:218: void FileData::addChild(FileData*): Assertion `mType == FOLDER' failed.
# Scenario where ES may Fail to Load is IF [parse XML gamelist only] is "OFF" + there are NO MP3s in the Dedicated Music Folders
# Scenario where RetroPie is Updated and Removes [.mp3] support from <extension>

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

# Put [startup.mp3] in [BGMbdir] If Not found
if [ ! -f "$BGMdir/startup.mp3" ]; then cp ~/RetroPie/retropiemenu/icons/impstartupm0.png "$BGMdir/startup.mp3" > /dev/null 2>&1; fi

# v2021.11 Addition - Runs at [IMP] install + Runs here in case of [RetroPie-Setup] Scripts gets Updated
rpsKODIautostart=~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh
rpsKODI='echo -e \"kodi #auto\\nemulationstation #auto\" >>\"$script\"'
rpsKODIsa='echo -e \"kodi-standalone #auto\\nemulationstation #auto\" >>\"$script\"'
rpsKODIes='echo \"emulationstation #auto\" >>\"$script\"'
impKODI='echo -e \"kodi #auto\\nbash \/opt\/retropie\/configs\/imp\/boot.sh > \/dev\/null 2>\&1 \& #auto\\nemulationstation #auto\" >>\"$script\"'
impKODIsa='echo -e \"kodi-standalone #auto\\nbash \/opt\/retropie\/configs\/imp\/boot.sh > \/dev\/null 2>\&1 \& #auto\\nemulationstation #auto\" >>\"$script\"'
impKODIes='echo -e \"bash \/opt\/retropie\/configs\/imp\/boot.sh > \/dev\/null 2>\&1 \& #auto\\nemulationstation #auto\" >>\"$script\"'

# Modifications to Retain [IMP] when Switching ES/Kodi on Boot from RetroPie-Setup
# --- [Default] [~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh]  ---
#            echo -e "kodi #auto\nemulationstation #auto" >>"$script"
#            echo -e "kodi-standalone #auto\nemulationstation #auto" >>"$script"
#            echo "emulationstation #auto" >>"$script"

# --- [IMP] [~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh]  ---
#            echo -e "kodi #auto\nbash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto\nemulationstation #auto" >>"$script"
#            echo -e "kodi-standalone #auto\nbash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto\nemulationstation #auto" >>"$script"
#            echo -e "bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto\nemulationstation #auto" >>"$script"

# Add [IMP] to the Auto-start ES/Kodi on Boot Script [~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh]
sed -i s+"$rpsKODI"+"$impKODI"+ $rpsKODIautostart
sed -i s+"$rpsKODIsa"+"$impKODIsa"+ $rpsKODIautostart
sed -i s+"$rpsKODIes"+"$impKODIes"+ $rpsKODIautostart

# # v2022.02 Addition - Scenario where RetroPie is Updated and Removes [.mp3] support from <extension>
# Check and Modify x2 Locations to keep parity: [/etc/emulationstation/es_systems.cfg] + [~/.emulationstation/es_systems.cfg]
#EXTesSYS='<extension>.rp .sh.*'
EXTesSYS='<extension>.rp .sh<\/extension>'
EXTesSYSimp='<extension>.rp .sh .mp3 .MP3 .pls .PLS .m3u .M3U<\/extension>'
CMDesSYS='<command>sudo \/home\/pi\/RetroPie-Setup\/retropie_packages.sh retropiemenu launch %ROM% \&lt;\/dev\/tty \&gt\;\/dev\/tty<\/command>'
CMDesSYShm='<command>sudo ~\/RetroPie-Setup\/retropie_packages.sh retropiemenu launch %ROM% \&lt;\/dev\/tty \&gt\;\/dev\/tty<\/command>'
CMDesSYSimp='<command>bash \/opt\/retropie\/configs\/all\/retropiemenu.sh %ROM%<\/command>'

# [es_systems.cfg] Modifications to allow [retropiemenu] to run Music files
# ------------ [Default] es_systems.cfg ------------ 
#    <extension>.rp .sh</extension>
#    <command>sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch %ROM% &lt;/dev/tty &gt;/dev/tty</command>

# ------------ [IMP] es_systems.cfg ------------ 
#    <extension>.rp .sh .mp3 .MP3 .pls .PLS .m3u .M3U </extension>
#    <command>bash /opt/retropie/configs/all/retropiemenu.sh %ROM%</command>      

# Add [IMP] to es_systems.cfg ETC if Missing - Scenario RetroPie Updated
if [ $(cat /etc/emulationstation/es_systems.cfg | grep -q "$EXTesSYSimp" ; echo $?) == '1' ]; then
	# Replace retropiemenu es_systems.cfg with [IMP]
	sudo sed -i s+"$EXTesSYS"+"$EXTesSYSimp"+ /etc/emulationstation/es_systems.cfg
	sudo sed -i s+"$CMDesSYS"+"$CMDesSYSimp"+ /etc/emulationstation/es_systems.cfg
	sudo sed -i s+"$CMDesSYShm"+"$CMDesSYSimp"+ /etc/emulationstation/es_systems.cfg
fi

# Add [IMP] to es_systems.cfg OPT if Missing - Scenario RetroPie Updated
if [ -f /opt/retropie/configs/all/emulationstation/es_systems.cfg ]; then
	if [ $(cat /opt/retropie/configs/all/emulationstation/es_systems.cfg | grep -q "$EXTesSYSimp" ; echo $?) == '1' ]; then
		# Replace retropiemenu es_systems.cfg with [IMP]
		sudo sed -i s+"$EXTesSYS"+"$EXTesSYSimp"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg
		sudo sed -i s+"$CMDesSYS"+"$CMDesSYSimp"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg
		sudo sed -i s+"$CMDesSYShm"+"$CMDesSYSimp"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg
	fi
fi

#tput reset
exit 0
