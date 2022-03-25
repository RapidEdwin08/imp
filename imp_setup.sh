#!/bin/bash

installFLAG=$1
versionIMP=$(cat ~/imp/VERSION)
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
IMPMenuRP=~/RetroPie/retropiemenu/imp
musicDIR=~/RetroPie/retropiemenu/imp/music
musicROMS=~/RetroPie/roms/music
musicROMSdisable=~/RetroPie/roms/music_disable
BGMdir="$musicDIR/bgm"
BGMa="$musicDIR/bgm/A-SIDE"
BGMb="$musicDIR/bgm/B-SIDE"

EXTesSYS='<extension>.rp .sh<\/extension>'
EXTesSYSimp='<extension>.rp .sh .mp3 .MP3 .pls .PLS .m3u .M3U<\/extension>'
CMDesSYS='<command>sudo \/home\/pi\/RetroPie-Setup\/retropie_packages.sh retropiemenu launch %ROM% \&lt;\/dev\/tty \&gt\;\/dev\/tty<\/command>'
CMDesSYShm='<command>sudo ~\/RetroPie-Setup\/retropie_packages.sh retropiemenu launch %ROM% \&lt;\/dev\/tty \&gt\;\/dev\/tty<\/command>'
CMDesSYSimp='<command>bash \/opt\/retropie\/configs\/all\/retropiemenu.sh %ROM%<\/command>'

rpsKODIautostart=~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh
rpsKODI='echo -e \"kodi #auto\\nemulationstation #auto\" >>\"$script\"'
rpsKODIsa='echo -e \"kodi-standalone #auto\\nemulationstation #auto\" >>\"$script\"'
rpsKODIes='echo \"emulationstation #auto\" >>\"$script\"'
impKODI='echo -e \"kodi #auto\\nbash \/opt\/retropie\/configs\/imp\/boot.sh > \/dev\/null 2>\&1 \& #auto\\nemulationstation #auto\" >>\"$script\"'
impKODIsa='echo -e \"kodi-standalone #auto\\nbash \/opt\/retropie\/configs\/imp\/boot.sh > \/dev\/null 2>\&1 \& #auto\\nemulationstation #auto\" >>\"$script\"'
impKODIes='echo -e \"bash \/opt\/retropie\/configs\/imp\/boot.sh > \/dev\/null 2>\&1 \& #auto\\nemulationstation #auto\" >>\"$script\"'

impLOGO=$(
echo "                               _-+-_                    "
echo "                              '#*=*#-                  "
echo "                         ^....-|:^:|:-../:^            "
echo "                         '-+++#::_::#+++-''            "
echo "                           ':--.-:-----::---:-            "
echo "                       '::.   -.------   .-:           "
echo "                        :-   ':------:. '::.           "
echo "                        =-'  .::-..-::-  ='            "
echo "                             .::-.'-:--                "
echo "                             '---. .-:'                "
echo "              Integrated      '::-'..-'      by     "
echo "              Music            .-- .--       RapidEdwin "
echo "              Player          .:-:.'''       v$versionIMP  "
echo "        ------------------------------------------------------- "
)

impFILEREF=$(
echo
echo "                         # FILE REFERENCES #"
echo "                             ~/.bashrc"
echo "                /etc/emulationstation/es_systems.cfg"
echo "             /opt/retropie/configs/all [retropiemenu.sh]"
echo "       [autostart.sh runcommand-onstart.sh runcommand-onend.sh]"
)

impFINISHREF=$(
echo
echo "                       # MUSIC DIRECTORIES #"
echo "                    $musicROMS"
echo "              $musicROMS/bgm/A-SIDE"
echo "              $musicROMS/bgm/B-SIDE"
echo
# echo "           /etc/emulationstation/es_systems.cfg"
# echo '         [.rp .sh .mp3 .MP3 .pls .PLS .m3u .M3U]'
# echo '   [bash /opt/retropie/configs/all/retropiemenu.sh %ROM%]'
echo
)

mpg123FILEREF=$(
echo
echo "                    # [mpg123] Install Utilities #"
echo "                        ~/imp/main-imp/offline"
echo "                        [mpg123-1.29.3.tar.bz2]"
echo "                        [mpg123-1.25.10.tar.bz2]"
echo "                        [mpg123-1.20.1.tar.bz2]"
echo
)
	
mpg123utils=$(
echo
echo "            *** [apt-get install] mpg123 [Recommended] ***"
echo
echo "[mpg123] Install Utilities can be Useful for [0ffline] Installs, or 0lder RetroPie images with 0utdated/Retired Repositories"
echo
echo "The [make-install] 0ptions Provided by the [IMP] Installer have been Configured For and Tested On [Pi Zero/W 1/2/3/4]"
echo
echo "Selecting a [make-install] 0ption could take a while, and will Require the SOURCE [~/imp/mpg123-1.x.y] Folder to Uninstall [mpg123]"
echo
echo "*DO NOT DELETE* [~/imp/mpg123-1.x.y] Folders If you want to be able to UNINSTALL [mpg123] from here later"
echo
echo
echo "         NOTE: [UNINSTALL] of [IMP] does NOT REMOVE [mpg123]  "
)

IMPesFIXref=$(
echo
echo "                          [es_systems.cfg]"
echo "                         /etc/emulationstation "
echo "             /opt/retropie/configs/all/emulationstation/ "
echo
#echo '                Modifications to [es_systems.cfg]'
echo '    <extension>.rp .sh .mp3 .MP3 .pls .PLS .m3u .M3U </extension>'
echo '<command>bash /opt/retropie/configs/all/retropiemenu.sh %ROM%</command>'
echo
echo "                            [gamelist.xml]"
echo "                       ~/RetroPie/retropiemenu "
echo "     /opt/retropie/configs/all/emulationstation/gamelists/retropie "
echo
echo "                              [smb.conf]"
echo "                         /etc/samba/smb.conf "
echo "           path = "/home/$USER/RetroPie/retropiemenu/imp/music""
)

customIMPREF=$(cat ~/imp/main-imp/templates/README)
IMPstandard="[STANDARD] IMP (Recommended)"
IMPcustom="[CUSTOM] IMP"
IMPmpg123="[mpg123] Utilities"
IMPesUTILS="[RP/ES]  Utilities"

mainMENU()
{
# Check for Internet Connection - internetSTATUS Displayed on Main Menu
wget -q --spider http://google.com
if [ $? -eq 0 ]; then
	internetSTATUS="  Internet Connection: [OK]  "
else
	internetSTATUS="   *INTERNET CONNECTION REQUIRED*   "
	if [ "$installFLAG" == 'offline' ]; then internetSTATUS="Offline-Install-Selected"; fi
fi

# Main Install Menu
tput reset
installTYPE=$(dialog --stdout --no-collapse --title "  $internetSTATUS" \
	--ok-label OK --cancel-label Exit \
	--menu "     Choose Type of Install for Integrated Music Player [IMP]:" 25 75 20 \
	1 "$IMPstandard" \
	2 "$IMPcustom" \
	3 "$IMPmpg123" \
	4 "$IMPesUTILS" \
	5 "Uninstall [IMP]")
tput reset

# If ESC then Exit
if [ "$installTYPE" == '' ]; then exit 0; fi

# Uninstall
if [ "$installTYPE" == '5' ]; then
	selectTYPE="UNINSTALL [IMP]"
	# Confirm Uninstall
	confREMOVE=$(dialog --stdout --no-collapse --title "               UNINSTALL [IMP]               " \
		--ok-label OK --cancel-label Back \
		--menu "                          ? ARE YOU SURE ?             " 25 75 20 \
		1 "><  $selectTYPE  ><" \
		2 "Back to Main Menu")
	# Uninstall Confirmed - Otherwise Back to Main Menu
	if [ "$confREMOVE" == '1' ]; then impUNINSTALL; fi
	mainMENU
fi

# [ES] Utilities
if [ "$installTYPE" == '4' ]; then
	selectTYPE="$IMPesUTILS"
	ESutilityMENU
fi

# mpg123 Manual Install
if [ "$installTYPE" == '3' ]; then
	# README mpg123 Manual Install
	dialog --no-collapse --title "   *DISCLAIMER* Use [mpg123] Install Utilities at your own Risk   " --ok-label CONTINUE --msgbox "$mpg123utils"  25 75
	
	# mpg123 Manual Install Menu
	mpg123MENU
fi

# Set installTYPEs to selectTYPEs
if [ "$installTYPE" == '1' ]; then selectTYPE="$IMPstandard"; fi
if [ "$installTYPE" == '2' ]; then selectTYPE="$IMPcustom"; fi

# STANDARD Install Files Creation
if [ "$selectTYPE" == "$IMPstandard" ]; then
	# Start with Clean Templates
	if [ -f main-imp/configs-all/autostart.sh ]; then rm main-imp/configs-all/autostart.sh; fi
	if [ -f main-imp/configs-all/runcommand-onend.sh ]; then rm main-imp/configs-all/runcommand-onend.sh; fi
	if [ -f main-imp/configs-all/runcommand-onstart.sh ]; then rm main-imp/configs-all/runcommand-onstart.sh; fi
	if [ -f main-imp/configs-all/attractmode.sh ]; then rm main-imp/configs-all/attractmode.sh; fi
	if [ -f main-imp/configs-all/emulationstation.sh ]; then rm main-imp/configs-all/emulationstation.sh; fi
	if [ -f main-imp/configs-all/pegasus.sh ]; then rm main-imp/configs-all/pegasus.sh; fi
	if [ -f main-imp/configs-all/AM-start.sh ]; then rm main-imp/configs-all/AM-start.sh; fi
	if [ -f main-imp/configs-all/ES-start.sh ]; then rm main-imp/configs-all/ES-start.sh; fi
	if [ -f main-imp/configs-all/Pegasus-start.sh ]; then rm main-imp/configs-all/Pegasus-start.sh; fi
	
	# Attempt to Seek out and Copy Current Scripts to be Installed in [/opt/retropie/configs/all/]
	if [ -f /opt/retropie/configs/all/autostart.sh ]; then
		if [ $(cat /opt/retropie/configs/all/autostart.sh | grep -q 'while pgrep omxplayer' ; echo $?) == '0' ]; then
			# Parse all lines Except [mpg123] [emulationstation] [kodi] [pegasus-fe #auto] [attract #auto] [pegasus-fe #auto] [attract #auto] [0ther BGMs]
			cat /opt/retropie/configs/all/autostart.sh | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" | grep -v "emulationstation #auto" | grep -v " --no-splash #auto" | grep -v "pegasus-fe #auto" | grep -v "attract #auto" | grep -v "kodi" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" > main-imp/configs-all/autostart.sh
		else
			# Add [while pgrep omxplayer >/dev/null; do sleep 1; done] if Not found
			echo 'while pgrep omxplayer >/dev/null; do sleep 1; done' > main-imp/configs-all/autostart.sh
			# Parse all lines Except [mpg123] [emulationstation] [kodi] [pegasus-fe #auto] [attract #auto] [pegasus-fe #auto] [attract #auto] [0ther BGMs]
			cat /opt/retropie/configs/all/autostart.sh | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" | grep -v "emulationstation #auto" | grep -v " --no-splash #auto" | grep -v "pegasus-fe #auto" | grep -v "attract #auto" | grep -v "kodi" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> main-imp/configs-all/autostart.sh
		fi
		# Add [kodi] if found
		if [ $(cat /opt/retropie/configs/all/autostart.sh | grep -q 'kodi #auto' ; echo $?) == '0' ]; then echo 'kodi #auto' >> main-imp/configs-all/autostart.sh; fi
		if [ $(cat /opt/retropie/configs/all/autostart.sh | grep -q 'kodi-standalone #auto' ; echo $?) == '0' ]; then echo 'kodi-standalone #auto' >> main-imp/configs-all/autostart.sh; fi
		# Add [IMP] [emulationstation]
		echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> main-imp/configs-all/autostart.sh
		echo 'emulationstation #auto' >> main-imp/configs-all/autostart.sh
	fi
	
	# [IMP] will be Added LAST to [runcommand-onend.sh]
	if [ -f /opt/retropie/configs/all/runcommand-onend.sh ]; then
		# Parse all lines Except [mpg123] [0ther BGMs]
		cat /opt/retropie/configs/all/runcommand-onend.sh | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" > main-imp/configs-all/runcommand-onend.sh
		echo 'bash /opt/retropie/configs/imp/run-onend.sh &' >> main-imp/configs-all/runcommand-onend.sh
	fi
	
	# [IMP] will be Added FIRST to [runcommand-onstart.sh]
	if [ ! -f main-imp/configs-all/runcommand-onstart.sh ] && [ -f /opt/retropie/configs/all/runcommand-onstart.sh ]; then
		# Parse all lines Except [mpg123] [0ther BGMs]
		echo 'bash /opt/retropie/configs/imp/run-onstart.sh' > main-imp/configs-all/runcommand-onstart.sh
		cat /opt/retropie/configs/all/runcommand-onstart.sh | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> main-imp/configs-all/runcommand-onstart.sh
	fi
	
	# CREATE Core [mpg123] Scripts if still NOT found
	if [ ! -f main-imp/configs-all/autostart.sh ]; then
		echo 'while pgrep omxplayer >/dev/null; do sleep 1; done' > main-imp/configs-all/autostart.sh
		echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> main-imp/configs-all/autostart.sh
		echo 'emulationstation #auto' >> main-imp/configs-all/autostart.sh
	fi
	if [ ! -f main-imp/configs-all/runcommand-onend.sh ]; then
		echo 'bash /opt/retropie/configs/imp/run-onend.sh &' > main-imp/configs-all/runcommand-onend.sh
	fi
	if [ ! -f main-imp/configs-all/runcommand-onstart.sh ]; then
		echo 'bash /opt/retropie/configs/imp/run-onstart.sh' > main-imp/configs-all/runcommand-onstart.sh
	fi
	
	# If Found Create Custom Scripts for Attract Mode and Pegasus in [retropiemenu]
	if [ -f ~/RetroPie/retropiemenu/attractmode.sh ]; then
		# Parse all lines Before [attract #auto] - Add [IMP] - Parse all lines After [attract #auto]
		LINEcountAMrp=$(grep -c ".*" ~/RetroPie/retropiemenu/attractmode.sh)
		grep -FB $LINEcountAMrp "attract #auto" ~/RetroPie/retropiemenu/attractmode.sh | grep -Fv "attract #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > main-imp/configs-all/attractmode.sh
		echo "#echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh" >> main-imp/configs-all/attractmode.sh
		grep -FA $LINEcountAMrp "attract #auto" ~/RetroPie/retropiemenu/attractmode.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> main-imp/configs-all/attractmode.sh
	fi
	
	if [ -f ~/RetroPie/retropiemenu/emulationstation.sh ]; then
		# Parse all lines Before [emulationstation #auto] - Add [IMP] - Parse all lines After [emulationstation #auto]
		LINEcountESrp=$(grep -c ".*" ~/RetroPie/retropiemenu/emulationstation.sh)
		grep -FB $LINEcountESrp "emulationstation #auto" ~/RetroPie/retropiemenu/emulationstation.sh | grep -Fv "emulationstation #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > main-imp/configs-all/emulationstation.sh
		echo "echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh" >> main-imp/configs-all/emulationstation.sh
		grep -FA $LINEcountESrp "emulationstation #auto" ~/RetroPie/retropiemenu/emulationstation.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> main-imp/configs-all/emulationstation.sh
	fi
	
	if [ -f ~/RetroPie/retropiemenu/pegasus.sh ]; then
		# Parse all lines Before [pegasus-fe #auto] - Add [IMP] - Parse all lines After [pegasus-fe #auto]
		LINEcountPGrp=$(grep -c ".*" ~/RetroPie/retropiemenu/pegasus.sh)
		grep -FB $LINEcountPGrp "pegasus-fe #auto" ~/RetroPie/retropiemenu/pegasus.sh | grep -Fv "pegasus-fe #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > main-imp/configs-all/pegasus.sh
		echo "echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh" >> main-imp/configs-all/pegasus.sh
		grep -FA $LINEcountPGrp "pegasus-fe #auto" ~/RetroPie/retropiemenu/pegasus.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> main-imp/configs-all/pegasus.sh
	fi
	
	# If Found Create Custom Scripts for Attract Mode and Pegasus in [attractmodemenu]
	if [ -f ~/RetroPie/attractmodemenu/emulationstation.sh ]; then
		# Parse all lines Before [emulationstation #auto] - Add [IMP] - Parse all lines After [emulationstation #auto]
		LINEcountESam=$(grep -c ".*" ~/RetroPie/attractmodemenu/emulationstation.sh)
		grep -FB $LINEcountESam "emulationstation #auto" ~/RetroPie/attractmodemenu/emulationstation.sh | grep -Fv "emulationstation #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > main-imp/configs-all/emulationstation.sh
		echo "echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh" >> main-imp/configs-all/emulationstation.sh
		grep -FA $LINEcountESam "emulationstation #auto" ~/RetroPie/attractmodemenu/emulationstation.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> main-imp/configs-all/emulationstation.sh
	fi
	
	if [ -f ~/RetroPie/attractmodemenu/pegasus.sh ]; then
		# Parse all lines Before [pegasus-fe #auto] - Add [IMP] - Parse all lines After [pegasus-fe #auto]
		LINEcountPGam=$(grep -c ".*" ~/RetroPie/attractmodemenu/pegasus.sh)
		grep -FB $LINEcountPGam "pegasus-fe #auto" ~/RetroPie/attractmodemenu/pegasus.sh | grep -Fv "pegasus-fe #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > main-imp/configs-all/pegasus.sh
		echo "echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh" >> main-imp/configs-all/pegasus.sh
		grep -FA $LINEcountPGam "pegasus-fe #auto" ~/RetroPie/attractmodemenu/pegasus.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> main-imp/configs-all/pegasus.sh
	fi
	
	# If Found Create Custom Scripts for Attract Mode and Pegasus in [/opt/retropie/configs/all/]
	if [ -f /opt/retropie/configs/all/AM-start.sh ]; then
		# Parse all lines Before [attract #auto] - Add [IMP] - Parse all lines After [attract #auto]
		LINEcountAMopt=$(grep -c ".*" /opt/retropie/configs/all/AM-start.sh)
		grep -FB $LINEcountAMopt "attract #auto" /opt/retropie/configs/all/AM-start.sh | grep -Fv "attract #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > main-imp/configs-all/AM-start.sh
		echo '#bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> main-imp/configs-all/AM-start.sh
		grep -FA $LINEcountAMopt "attract #auto" /opt/retropie/configs/all/AM-start.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> main-imp/configs-all/AM-start.sh
	fi
	
	if [ -f /opt/retropie/configs/all/ES-start.sh ]; then
		# Parse all lines Before [emulationstation #auto] - Add [IMP] - Parse all lines After [emulationstation #auto]
		LINEcountESopt=$(grep -c ".*" /opt/retropie/configs/all/ES-start.sh)
		grep -FB $LINEcountESopt "emulationstation #auto" /opt/retropie/configs/all/ES-start.sh | grep -Fv "emulationstation #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > main-imp/configs-all/ES-start.sh
		echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> main-imp/configs-all/ES-start.sh
		grep -FA $LINEcountESopt "emulationstation #auto" /opt/retropie/configs/all/ES-start.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> main-imp/configs-all/ES-start.sh
	fi
	
	if [ -f /opt/retropie/configs/all/Pegasus-start.sh ]; then
		# Parse all lines Before [pegasus-fe #auto] - Add [IMP] - Parse all lines After [pegasus-fe #auto]
		LINEcountPGopt=$(grep -c ".*" /opt/retropie/configs/all/Pegasus-start.sh)
		grep -FB $LINEcountPGopt "pegasus-fe #auto" /opt/retropie/configs/all/Pegasus-start.sh | grep -Fv "pegasus-fe #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > main-imp/configs-all/Pegasus-start.sh
		echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> main-imp/configs-all/Pegasus-start.sh
		grep -FA $LINEcountPGopt "pegasus-fe #auto" /opt/retropie/configs/all/Pegasus-start.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> main-imp/configs-all/Pegasus-start.sh
	fi
fi

# CUSTOM Install Files Creation
if [ "$selectTYPE" == "$IMPcustom" ]; then
	# Check for the Most Important Setup Directories and Core mpg123 Scripts [custom-imp/*] - CREATE them if NOT found
	if [ ! -d custom-imp/ ]; then mkdir custom-imp; fi
	if [ ! -d custom-imp/templates/ ]; then mkdir custom-imp/templates; fi
	
	# Attempt to Seek out and Copy Current Scripts to be Installed in [/opt/retropie/configs/all/]
	if [ ! -f custom-imp/autostart.sh ] && [ -f /opt/retropie/configs/all/autostart.sh ]; then
		if [ $(cat /opt/retropie/configs/all/autostart.sh | grep -q 'while pgrep omxplayer' ; echo $?) == '0' ]; then
			# Parse all lines Except [mpg123] [emulationstation] [kodi] [pegasus-fe #auto] [attract #auto] [pegasus-fe #auto] [attract #auto] [0ther BGMs]
			cat /opt/retropie/configs/all/autostart.sh | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" | grep -v "emulationstation #auto" | grep -v " --no-splash #auto" | grep -v "pegasus-fe #auto" | grep -v "attract #auto" | grep -v "kodi" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" > custom-imp/autostart.sh
		else
			# Add [while pgrep omxplayer >/dev/null; do sleep 1; done] if Not found
			echo 'while pgrep omxplayer >/dev/null; do sleep 1; done' > custom-imp/autostart.sh
			# Parse all lines Except [mpg123] [emulationstation] [kodi] [pegasus-fe #auto] [attract #auto] [pegasus-fe #auto] [attract #auto] [0ther BGMs]
			cat /opt/retropie/configs/all/autostart.sh | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" | grep -v "emulationstation #auto" | grep -v " --no-splash #auto" | grep -v "pegasus-fe #auto" | grep -v "attract #auto" | grep -v "kodi" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> custom-imp/autostart.sh
		fi
		
		# Add [kodi] if found
		if [ $(cat /opt/retropie/configs/all/autostart.sh | grep -q 'kodi #auto' ; echo $?) == '0' ]; then echo 'kodi #auto' >> custom-imp/autostart.sh; fi
		if [ $(cat /opt/retropie/configs/all/autostart.sh | grep -q 'kodi-standalone #auto' ; echo $?) == '0' ]; then echo 'kodi-standalone #auto' >> custom-imp/autostart.sh; fi
		
		# Add [IMP] [emulationstation]
		echo '#[IMP] THIS LINE SHOULD BE ABOVE [emulationstation #auto]'  >> custom-imp/autostart.sh
		echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> custom-imp/autostart.sh
		echo 'emulationstation #auto' >> custom-imp/autostart.sh
	fi
	
	# [IMP] will be Added LAST to [runcommand-onend.sh]
	if [ ! -f custom-imp/runcommand-onend.sh ] && [ -f /opt/retropie/configs/all/runcommand-onend.sh ]; then
		# Parse all lines Except [mpg123] [0ther BGMs]
		cat /opt/retropie/configs/all/runcommand-onend.sh | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" > custom-imp/runcommand-onend.sh
		echo '#[IMP] THIS LINE CAN BE LAST'  >> custom-imp/runcommand-onend.sh
		echo 'bash /opt/retropie/configs/imp/run-onend.sh &' >> custom-imp/runcommand-onend.sh
	fi
	
	# [IMP] will be Added FIRST to [runcommand-onstart.sh]
	if [ ! -f custom-imp/runcommand-onstart.sh ] && [ -f /opt/retropie/configs/all/runcommand-onstart.sh ]; then
		# Parse all lines Except [mpg123] [0ther BGMs]
		echo '#[IMP] THIS LINE CAN BE FIRST'  > custom-imp/runcommand-onstart.sh
		echo 'bash /opt/retropie/configs/imp/run-onstart.sh' >> custom-imp/runcommand-onstart.sh
		cat /opt/retropie/configs/all/runcommand-onstart.sh | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> custom-imp/runcommand-onstart.sh
	fi
	
	# CREATE Core [mpg123] Scripts if still NOT found
	if [ ! -f custom-imp/autostart.sh ]; then
		echo 'while pgrep omxplayer >/dev/null; do sleep 1; done' > custom-imp/autostart.sh
		echo '#[IMP] THIS LINE SHOULD BE ABOVE [emulationstation #auto]'  >> custom-imp/autostart.sh
		echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> custom-imp/autostart.sh
		echo 'emulationstation #auto' >> custom-imp/autostart.sh
	fi
	if [ ! -f custom-imp/runcommand-onend.sh ]; then
		echo '#[IMP] THIS LINE CAN BE LAST'  >> custom-imp/runcommand-onend.sh
		echo 'bash /opt/retropie/configs/imp/run-onend.sh &' >> custom-imp/runcommand-onend.sh
	fi
	if [ ! -f custom-imp/runcommand-onstart.sh ]; then
		echo '#[IMP] THIS LINE CAN BE FIRST'  > custom-imp/runcommand-onstart.sh
		echo 'bash /opt/retropie/configs/imp/run-onstart.sh' >> custom-imp/runcommand-onstart.sh
	fi
	
	# 0PTIONAL Seek out and Copy Current Scripts to be Installed for Attract Mode/ES/Pegasus
	if [ ! -f custom-imp/attractmode.sh ] && [ -f ~/RetroPie/retropiemenu/attractmode.sh ]; then
		# Parse all lines Before [attract #auto] - Add [IMP] - Parse all lines After [attract #auto]
		LINEcountAMrp=$(grep -c ".*" ~/RetroPie/retropiemenu/attractmode.sh)
		grep -FB $LINEcountAMrp "attract #auto" ~/RetroPie/retropiemenu/attractmode.sh | grep -Fv "attract #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > custom-imp/attractmode.sh
		echo '#[IMP] THIS LINE SHOULD BE ABOVE [attract #auto] - #UNCOMMENT IF YOU WANT [IMP] TO START IN ATTRACT MODE'  >> custom-imp/attractmode.sh
		echo "#echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh" >> custom-imp/attractmode.sh
		grep -FA $LINEcountAMrp "attract #auto" ~/RetroPie/retropiemenu/attractmode.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> custom-imp/attractmode.sh
	fi
	
	if [ ! -f custom-imp/emulationstation.sh ] && [ -f ~/RetroPie/retropiemenu/emulationstation.sh ]; then
		# Parse all lines Before [emulationstation #auto] - Add [IMP] - Parse all lines After [emulationstation #auto]
		LINEcountESrp=$(grep -c ".*" ~/RetroPie/retropiemenu/emulationstation.sh)
		grep -FB $LINEcountESrp "emulationstation #auto" ~/RetroPie/retropiemenu/emulationstation.sh | grep -Fv "emulationstation #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > custom-imp/emulationstation.sh
		echo '#[IMP] THIS LINE SHOULD BE ABOVE [emulationstation #auto]'  >> custom-imp/emulationstation.sh
		echo "echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh" >> custom-imp/emulationstation.sh
		grep -FA $LINEcountESrp "emulationstation #auto" ~/RetroPie/retropiemenu/emulationstation.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> custom-imp/emulationstation.sh
	fi
	
	if [ ! -f custom-imp/pegasus.sh ] && [ -f ~/RetroPie/retropiemenu/pegasus.sh ]; then
		# Parse all lines Before [pegasus-fe #auto] - Add [IMP] - Parse all lines After [pegasus-fe #auto]
		grep -FB $LINEcountPGrp "pegasus-fe #auto" ~/RetroPie/retropiemenu/pegasus.sh | grep -Fv "pegasus-fe #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > custom-imp/pegasus.sh
		LINEcountPGrp=$(grep -c ".*" ~/RetroPie/retropiemenu/pegasus.sh)
		echo '#[IMP] THIS LINE SHOULD BE ABOVE [pegasus-fe #auto]'  >> custom-imp/pegasus.sh
		echo "echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh" >> custom-imp/pegasus.sh
		grep -FA $LINEcountPGrp "pegasus-fe #auto" ~/RetroPie/retropiemenu/pegasus.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> custom-imp/pegasus.sh
	fi
	
	if [ ! -f custom-imp/emulationstation.sh ] && [ -f ~/RetroPie/attractmodemenu/emulationstation.sh ]; then
		# Parse all lines Before [emulationstation #auto] - Add [IMP] - Parse all lines After [emulationstation #auto]
		LINEcountESam=$(grep -c ".*" ~/RetroPie/attractmodemenu/emulationstation.sh)
		grep -FB $LINEcountESam "emulationstation #auto" ~/RetroPie/attractmodemenu/emulationstation.sh | grep -Fv "emulationstation #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > custom-imp/emulationstation.sh
		echo '#[IMP] THIS LINE SHOULD BE ABOVE [emulationstation #auto]'  >> custom-imp/emulationstation.sh
		echo "echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh" >> custom-imp/emulationstation.sh
		grep -FA $LINEcountESam "emulationstation #auto" ~/RetroPie/attractmodemenu/emulationstation.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> custom-imp/emulationstation.sh
	fi
	
	if [ ! -f custom-imp/pegasus.sh ] && [ -f ~/RetroPie/attractmodemenu/pegasus.sh ]; then
		# Parse all lines Before [pegasus-fe #auto] - Add [IMP] - Parse all lines After [pegasus-fe #auto]
		LINEcountPGam=$(grep -c ".*" ~/RetroPie/attractmodemenu/pegasus.sh)
		grep -FB $LINEcountPGam "pegasus-fe #auto" ~/RetroPie/attractmodemenu/pegasus.sh | grep -Fv "pegasus-fe #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > custom-imp/pegasus.sh
		echo '#[IMP] THIS LINE SHOULD BE ABOVE [pegasus-fe #auto]'  >> custom-imp/pegasus.sh
		echo "echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh" >> custom-imp/pegasus.sh
		grep -FA $LINEcountPGam "pegasus-fe #auto" ~/RetroPie/attractmodemenu/pegasus.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> custom-imp/pegasus.sh
	fi
	
	# 0PTIONAL Seek out and Copy Current Scripts to be Installed in [/opt/retropie/configs/all/]
	if [ ! -f custom-imp/AM-start.sh ] && [ -f /opt/retropie/configs/all/AM-start.sh ]; then
		# Parse all lines Before [attract #auto] - Add [IMP] - Parse all lines After [attract #auto]
		LINEcountAMopt=$(grep -c ".*" /opt/retropie/configs/all/AM-start.sh)
		grep -FB $LINEcountAMopt "attract #auto" /opt/retropie/configs/all/AM-start.sh | grep -Fv "attract #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > custom-imp/AM-start.sh
		echo '#[IMP] THIS LINE SHOULD BE ABOVE [attract #auto] - #UNCOMMENT IF YOU WANT [IMP] TO START IN ATTRACT MODE'  >> custom-imp/AM-start.sh
		echo '#bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> custom-imp/AM-start.sh
		grep -FA $LINEcountAMopt "attract #auto" /opt/retropie/configs/all/AM-start.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> custom-imp/AM-start.sh
	fi
	
	if [ ! -f custom-imp/ES-start.sh ] && [ -f /opt/retropie/configs/all/ES-start.sh ]; then
		# Parse all lines Before [emulationstation #auto] - Add [IMP] - Parse all lines After [emulationstation #auto]
		LINEcountESopt=$(grep -c ".*" /opt/retropie/configs/all/ES-start.sh)
		grep -FB $LINEcountESopt "emulationstation #auto" /opt/retropie/configs/all/ES-start.sh | grep -Fv "emulationstation #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > custom-imp/ES-start.sh
		echo '#[IMP] THIS LINE SHOULD BE ABOVE [emulationstation #auto]'  >> custom-imp/ES-start.sh
		echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> custom-imp/ES-start.sh
		grep -FA $LINEcountESopt "emulationstation #auto" /opt/retropie/configs/all/ES-start.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> custom-imp/ES-start.sh
	fi
	
	if [ ! -f custom-imp/Pegasus-start.sh ] && [ -f /opt/retropie/configs/all/Pegasus-start.sh ]; then
		# Parse all lines Before [pegasus-fe #auto] - Add [IMP] - Parse all lines After [pegasus-fe #auto]
		LINEcountPGopt=$(grep -c ".*" /opt/retropie/configs/all/Pegasus-start.sh)
		grep -FB $LINEcountPGopt "pegasus-fe #auto" /opt/retropie/configs/all/Pegasus-start.sh | grep -Fv "pegasus-fe #auto" | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" | grep -v "mpg123" | grep -v "audacious"| grep -v "BGM" | grep -v "bgm" | grep -v "retropie_music" | grep -v "DisableMusic" | grep -v "music_disable" > custom-imp/Pegasus-start.sh
		echo '#[IMP] THIS LINE SHOULD BE ABOVE [pegasus-fe #auto]'  >> custom-imp/Pegasus-start.sh
		echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> custom-imp/Pegasus-start.sh
		grep -FA $LINEcountPGopt "pegasus-fe #auto" /opt/retropie/configs/all/Pegasus-start.sh | grep -Fv "/opt/retropie/configs/imp/" | grep -Fv "#[IMP]" >> custom-imp/Pegasus-start.sh
	fi
	
	# Create Templates for Reference
	if [ ! -f custom-imp/README ]; then cp main-imp/templates/README custom-imp/README; fi
	if [ ! -f custom-imp/templates/autostart.sh ]; then cp main-imp/templates/autostart.sh custom-imp/templates/autostart.sh; fi
	if [ ! -f custom-imp/templates/runcommand-onend.sh ]; then cp main-imp/templates/runcommand-onend.sh custom-imp/templates/runcommand-onend.sh; fi
	if [ ! -f custom-imp/templates/runcommand-onstart.sh ]; then cp main-imp/templates/runcommand-onstart.sh custom-imp/templates/runcommand-onstart.sh; fi
	if [ ! -f custom-imp/templates/attractmode.sh ]; then cp main-imp/templates/attractmode.sh custom-imp/templates/attractmode.sh; fi
	if [ ! -f custom-imp/templates/emulationstation.sh ]; then cp main-imp/templates/emulationstation.sh custom-imp/templates/emulationstation.sh; fi
	if [ ! -f custom-imp/templates/pegasus.sh ]; then cp main-imp/templates/pegasus.sh custom-imp/templates/pegasus.sh; fi
	if [ ! -f custom-imp/templates/AM-start.sh ]; then cp main-imp/templates/AM-start.sh custom-imp/templates/AM-start.sh; fi
	if [ ! -f custom-imp/templates/ES-start.sh ]; then cp main-imp/templates/ES-start.sh custom-imp/templates/ES-start.sh; fi
	if [ ! -f custom-imp/templates/Pegasus-start.sh ]; then cp main-imp/templates/Pegasus-start.sh custom-imp/templates/Pegasus-start.sh; fi
	if [ ! -f custom-imp/templates/Current\ Playlist.sh ]; then cp main-imp/templates/Current\ Playlist.sh custom-imp/templates/Current\ Playlist.sh; fi
	if [ ! -f custom-imp/templates/Current\ Settings.sh ]; then cp main-imp/templates/Current\ Settings.sh custom-imp/templates/Current\ Settings.sh; fi
	if [ ! -f custom-imp/templates/HTTP\ Server\ Log.sh ]; then cp main-imp/templates/HTTP\ Server\ Log.sh custom-imp/templates/HTTP\ Server\ Log.sh; fi
	if [ ! -f custom-imp/templates/custom-imp.sh ]; then
		echo '#!/bin/bash' > custom-imp/templates/custom-imp.sh
		echo '# Put CUSTOM Commands for [IMP] Install HERE' >> custom-imp/templates/custom-imp.sh
		echo '' >> custom-imp/templates/custom-imp.sh
		echo '' >> custom-imp/templates/custom-imp.sh
		echo '' >> custom-imp/templates/custom-imp.sh
		echo 'exit 0' >> custom-imp/templates/custom-imp.sh
	fi
	
	# Identify Pi Hardware Model
	piHW=$(tr -d '\0' < /proc/device-tree/model)
	detectTYPE="[UNKNOWN] Non-Default RetroPie Image?"
	if [ "$(cat ~/.bashrc | grep -q 'SuPreMe' ; echo $?)" == '0' ] || [ "$(cat ~/.bashrc | grep -q 'SUPREME' ; echo $?)" == '0' ]; then detectTYPE="[UNKNOWN] ?SuPreMe Base Image?"; fi
	
	# Perform Unique checks according to KNOWN Pre-Made Images already TESTED with [IMP]
	if [ "$(cat ~/.bashrc | grep -q 'SuPreMe BuiLd PI 0/2/3/3+ V2' ; echo $?)" == '0' ]; then detectTYPE="[SUPREME] Arcade Build V2 (PiZero 20180827)"; fi
	if [ "$(cat ~/.bashrc | grep -q 'SUPREME GPI BY the Supreme Team' ; echo $?)" == '0' ]; then detectTYPE="[SUPREME] GPI V1 (PiZero/W + GPI 20190710)"; fi
	if [ "$(cat ~/.bashrc | grep -q 'SUPREME GPI V2 BY Supreme Team' ; echo $?)" == '0' ]; then detectTYPE="[SUPREME] GPI V2 (PiZero/W + GPI 20191108)"; fi
	if [ "$(cat ~/.bashrc | grep -q 'SUPREME GPIMate V1 BY Supreme Team' ; echo $?)" == '0' ]; then detectTYPE="[SUPREME] GPIMate V1 (Pi/CM3 + GPI 20200408)"; fi
	if [ "$(cat ~/.bashrc | grep -q 'SUPREME UNIFIED BY the Supreme team' ; echo $?)" == '0' ]; then detectTYPE="[SUPREME] Unified (Pi3A/B/B+ 20190514)"; fi
	if [ "$(cat ~/.bashrc | grep -q 'SUPREME PRO RPI23b+ By Supreme Team' ; echo $?)" == '0' ]; then detectTYPE="[SUPREME] Pro (Pi2/3/B+ 20200509)"; fi
	if [ "$(cat ~/.bashrc | grep -q 'SUPREME PRO BY THE SUPREME TEAM' ; echo $?)" == '0' ]; then detectTYPE="[SUPREME] Pro (Pi4 20200401)"; fi
	if [ "$(cat ~/.bashrc | grep -q 'SUPREME DUO BY THE SUPREME TEAM AND monkaBlyat.' ; echo $?)" == '0' ]; then detectTYPE="[SUPREME] Duo (Unofficial) (Pi4B 20200104)"; fi
	if [ "$(cat ~/.bashrc | grep -q 'SUPREME ULTRA V1 BY THE SUPREME TEAM' ; echo $?)" == '0' ]; then detectTYPE="[SUPREME] Ultra V1 (Pi4 20210121)"; fi
	if [ -d /opt/retropie/configs/all/emulationstation/themes/MB\ Custom\ Back\ to\ the\ Future\ Theme\ 2020-21/ ]; then detectTYPE="[MBM] BTTF PleasureParadise (Pi4 19851026)"; fi
	
	# README Custom Install
	dialog --no-collapse --title " $detectTYPE $piHW" --ok-label CONTINUE --msgbox "$customIMPREF"  25 75
fi

# Check for Internet Connection - If Internet Confirm Install - If No Internet Back to Main Menu
wget -q --spider http://google.com
# if [ $? -eq 0 ]; then# Adding OFFLINE OPTION
if [[ $? -eq 0 || "$installFLAG" == 'offline' ]]; then
	# Confirm Install
	confSTATUS="OK"
	if [ "$installFLAG" == 'offline' ]; then confSTATUS="Offline-Install-Selected"; fi
	confINSTALL=$(dialog --stdout --no-collapse --title "  Internet Connection: [$confSTATUS]  " \
		--ok-label OK --cancel-label Back \
		--menu "                           ? ARE YOU SURE ?             " 25 75 20 \
		1 "INSTALL $selectTYPE" \
		2 "Choose Type of [IMP] Install")
	# Install Confirmed - Otherwise Back to Main Menu
	if [ "$confINSTALL" == '1' ]; then impINSTALL; fi
	mainMENU
else
	# No Internet - Back to Main Menu
	dialog --no-collapse --title "               [ERROR]               " --msgbox "   *INTERNET CONNECTION REQUIRED*"  25 75
	mainMENU
fi

tput reset
exit 0
}

impINSTALL()
{
tput reset

if [ "$selectTYPE" == "$IMPcustom" ]; then
	# Check for the Most Important Setup Directories and Files [custom-imp/*] After Modifications
	if [ ! -d custom-imp/ ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [custom-imp/*] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
		mainMENU
	fi
	if [ ! -f custom-imp/autostart.sh ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [custom-imp/autostart.sh] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
		mainMENU
	fi
	if [ ! -f custom-imp/runcommand-onend.sh ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [custom-imp/runcommand-onend.sh] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
		mainMENU
	fi
	if [ ! -f custom-imp/runcommand-onstart.sh ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [custom-imp/runcommand-onstart.sh] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
		mainMENU
	fi
fi

if [ "$selectTYPE" == "$IMPstandard" ]; then
	# Check for the Most Important Setup Directories and Files [configs-all/*]
	if [ ! -f main-imp/configs-all/autostart.sh ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [configs-all/autostart.sh] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
		mainMENU
	fi

	# Check for the Most Important Setup Directories and Files [configs-all/*]
	if [ ! -f main-imp/configs-all/runcommand-onend.sh ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [configs-all/runcommand-onend.sh] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
		mainMENU
	fi

	# Check for the Most Important Setup Directories and Files [configs-all/*]
	if [ ! -f main-imp/configs-all/runcommand-onstart.sh ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [configs-all/runcommand-onstart.sh] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
		mainMENU
	fi
fi

# Check for the Most Important Setup Directories and Files [main-imp/*]
if [ ! -d main-imp/ ]; then
	dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [main-imp/*] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
	mainMENU
fi

# Check for the Most Important Setup Directories and Files [configs-all/*]
if [ ! -d main-imp/configs-all ]; then
	dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [main-imp/configs-all/*] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
	mainMENU
fi

# Check for the Most Important Setup Directories and Files [configs-all/*]
if [ ! -f main-imp/configs-all/retropiemenu.sh ]; then
	dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [configs-all/retropiemenu.sh] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
	mainMENU
fi

# Check for the Most Important Setup Directories and Files [configs-imp/*]
if [ ! -d main-imp/configs-imp ]; then
	dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [main-imp/configs-imp/*] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
	mainMENU
fi

# Check for the Most Important Setup Directories and Files [gamelist]
if [ ! -f main-imp/gamelist.imp ]; then
	dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [main-imp/gamelist.imp] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
	mainMENU
fi

# Check if [IMP] already Installed
if [ -d $IMP ]; then
	dialog --no-collapse --title "   * [IMP] INSTALL DETECTED *   *UNINSTALL [IMP] FIRST *" --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75
	mainMENU
fi

# Disable 0ther BGMs Indiscriminately
sudo pkill -STOP mpg123 > /dev/null 2>&1
sudo pkill -KILL mpg123 > /dev/null 2>&1

# Backup Various backgroundmusic scripts
if [ -f ~/RetroPie/retropiemenu/backgroundmusic.sh ]; then mv ~/RetroPie/retropiemenu/backgroundmusic.sh ~/RetroPie/retropiemenu/backgroundmusic.sh.b4imp; fi
if [ -f ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh ]; then mv ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh.b4imp; fi
if [ -f ~/RetroPie/retropiemenu/audiotools/backgroundmusic.sh ]; then mv ~/RetroPie/retropiemenu/audiotools/backgroundmusic.sh ~/RetroPie/retropiemenu/audiotools/backgroundmusic.sh.b4imp; fi

# Disable Livewire
if [ ! -f ~/.DisableMusic ]; then touch ~/.DisableMusic; fi
if [ -f /home/pi/RetroPie/retropiemenu/bgm-mute.sh ]; then mv /home/pi/RetroPie/retropiemenu/bgm-mute.sh /home/pi/RetroPie/retropiemenu/bgm-mute.sh.b4imp; fi

# Disable BGM Naprosnia
sudo pkill -STOP audacious > /dev/null 2>&1
sudo pkill -KILL audacious > /dev/null 2>&1
if [ -f ~/RetroPie-BGM-Player/bgm_system.sh ]; then bash ~/RetroPie-BGM-Player/bgm_system.sh -setsetting bgm_toggle 0; fi
# if [ -f ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh ]; then mv ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh.b4imp 2>/dev/null; fi
if [ -f ~/RetroPie/retropiemenu/RetroPie-BGM-Player.sh ]; then mv ~/RetroPie/retropiemenu/RetroPie-BGM-Player ~/RetroPie/retropiemenu/RetroPie-BGM-Player.sh.b4imp 2>/dev/null; fi

# Disable BGM Rydra
sudo systemctl stop bgm > /dev/null 2>&1
sudo systemctl disable bgm > /dev/null 2>&1
# sudo systemctl daemon-reload > /dev/null 2>&1

# Disable BGM 0fficialPhilcomm
sudo systemctl stop retropie_music > /dev/null 2>&1
sudo systemctl disable retropie_music > /dev/null 2>&1
# sudo systemctl daemon-reload > /dev/null 2>&1

# Final daemon-reload after Disable 0ther BGMs
sudo systemctl daemon-reload > /dev/null 2>&1

# Install mpg123 if NOT already installed
# Expected Result: bash: /usr/bin/mpg123: No such file or directory
# Expected Result: Command 'mpg123' not found, did you mean:
# Expected Result: mpg123 1.25.10
if [[ ! "$(mpg123 --version)" == "mpg123 1."* ]]; then
	# sudo apt-get -y install mpg123 #Adding OFFLINE OPTION
	if [ ! "$installFLAG" == 'offline' ]; then sudo apt-get -y install mpg123; fi
fi

# Confirm mpg123 Installed - Back out of Install if NOT
if [[ ! "$(mpg123 --version)" == "mpg123 1."* ]]; then
	dialog --no-collapse --title " * ERROR [mpg123] IS REQUIRED *" --ok-label "Main Menu" --msgbox "[mpg123] DOES NOT APPEAR TO BE INSTALLED! Verify Internet Connection and/or [apt-get update] Repositories before attempting Install."  25 75
	mainMENU
fi

# Create Directories
if [ ! -d "$IMP" ]; then mkdir "$IMP"; fi
if [ ! -d "$IMPSettings" ]; then mkdir "$IMPSettings"; fi
if [ ! -d "$IMPPlaylist" ]; then mkdir "$IMPPlaylist"; fi
if [ ! -d "$IMPMenuRP" ]; then mkdir "$IMPMenuRP"; fi

# Put [music] IN [retropiemenu] - ES may not play well with References to Symbolic Links in [retropiemenu]
if [ -d "$musicROMSdisable" ]; then mv "$musicROMSdisable" "$musicROMS"; fi
if [ -d "$musicROMS" ]; then
	if [ ! $(readlink "$musicROMS") == '' ]; then
		# If Symbolic Link - Remove current Link to [roms/music] - Create New Link to [retropiemenu/imp/music/romsLINK]
		romsLINK=$(readlink "$musicROMS" | sed 's/.*\///' )
		if [ ! -d "$musicDIR" ]; then mkdir "$musicDIR"; fi
		if [ ! -d "$musicDIR" ]; then mkdir "$musicDIR/_$romsLINK"; fi
		ln -s $(readlink "$musicROMS") "$musicDIR/_$romsLINK"
		rm "$musicROMS"
	else
		# If NOT Symbolic Link Move [roms/music] Folder to [retropiemenu/imp/music]
		mv "$musicROMS" "$musicDIR"
	fi
fi
# Create the [roms/music] Folder - Symbolic Link [retropiemenu/imp/music] to [roms/music]
if [ ! -d "$musicDIR" ]; then mkdir "$musicDIR"; fi
if [ ! -d "$musicROMS" ]; then ln -s "$musicDIR" "$musicROMS"; fi
# Create Symbolic Links to 0ther Various Music Folders
if [ -d ~/RetroPie/roms/jukebox/mp3 ] && [ ! -d "$musicROMS/_jukebox_mp3" ]; then ln -s ~/RetroPie/roms/jukebox/mp3 "$musicROMS/_jukebox_mp3"; fi
if [ -d ~/bgm ] && [ ! -d "$musicROMS/_bgm" ]; then ln -s ~/bgm "$musicDIR/_bgm"; fi
if [ -d ~/RetroPie/backgroundmusic_disable ]; then mv ~/RetroPie/backgroundmusic_disable ~/RetroPie/backgroundmusic; fi
if [ -d ~/RetroPie/backgroundmusic ] && [ ! -d "$musicDIR/_backgroundmusic" ]; then ln -s ~/RetroPie/backgroundmusic "$musicDIR/_backgroundmusic"; fi
# if [ -d ~/.attract/sounds ] && [ ! -d "$musicDIR/_AttractModeSounds" ]; then ln -s ~/.attract/sounds "$musicDIR/_AttractModeSounds"; fi

if [ ! -d "$BGMdir" ]; then mkdir "$BGMdir"; fi
if [ ! -d "$BGMa" ]; then mkdir "$BGMa"; fi
if [ ! -d "$BGMb" ]; then mkdir "$BGMb"; fi
if [ ! -d "$IMPMenuRP/Settings" ]; then mkdir "$IMPMenuRP/Settings"; fi
if [ ! -d "$IMPMenuRP/Settings/BGM Settings" ]; then mkdir "$IMPMenuRP/Settings/BGM Settings"; fi
if [ ! -d "$IMPMenuRP/Settings/Game Settings" ]; then mkdir "$IMPMenuRP/Settings/Game Settings"; fi
if [ ! -d "$IMPMenuRP/Settings/HTTP Server Settings" ]; then mkdir "$IMPMenuRP/Settings/HTTP Server Settings"; fi
if [ ! -d "$IMPMenuRP/Settings/Randomizer Settings" ]; then mkdir "$IMPMenuRP/Settings/Randomizer Settings"; fi
if [ ! -d "$IMPMenuRP/Settings/Startup Settings" ]; then mkdir "$IMPMenuRP/Settings/Startup Settings"; fi
if [ ! -d "$IMPMenuRP/Volume" ]; then mkdir "$IMPMenuRP/Volume"; fi

# Copy Files to configs
cp -R main-imp/configs-imp/* "$IMP"
sudo chmod 755 $IMP/*.sh

# Copy Files to retropiemenu
cp -R main-imp/retropiemenu/* $IMPMenuRP

# Backup autostart.sh if not exist already
if [ ! -f /opt/retropie/configs/all/autostart.sh.b4imp ] && [ -f /opt/retropie/configs/all/autostart.sh ]; then
	mv /opt/retropie/configs/all/autostart.sh /opt/retropie/configs/all/autostart.sh.b4imp
fi

# Backup runcommand-onstart if not exist already
if [ ! -f /opt/retropie/configs/all/runcommand-onstart.sh.b4imp ]; then
	mv /opt/retropie/configs/all/runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh.b4imp 2>/dev/null
fi

# Backup runcommand-onend if not exist already
if [ ! -f /opt/retropie/configs/all/runcommand-onend.sh.b4imp ]; then
	mv /opt/retropie/configs/all/runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh.b4imp 2>/dev/null
fi

# Backup [~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh] if not exist already
if [ ! -f ~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh.b4imp ]; then
	cp ~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh ~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh.b4imp
fi

# Remove [mpg123] [BGM] from [rc.local] if found
mpg123RC=$(cat /etc/rc.local | grep -q 'mpg123' ; echo $?)
bgmRC=$(cat /etc/rc.local | grep -q 'BGM' ; echo $?)
if [ "$mpg123RC" == '0' ] || [ "$bgmRC" == '0' ]; then
	# Parse all lines Except [mpg123] [BGM]
	# cat /etc/rc.local | grep -Fv "(sleep 20; mpg123 -Z /home/pi/RetroPie/roms/music/*.mp3 >/dev/null 2>&1) &" > main-imp/rc.local
	cat /etc/rc.local | grep -v "mpg123" | grep -v "BGM" > main-imp/rc.local
	
	# Backup [rc.local] if not exist already
	if [ ! -f /etc/rc.local.b4imp ]; then sudo cp /etc/rc.local /etc/rc.local.b4imp 2>/dev/null; fi
	
	# Replace [rc.local] with [mpg123] Removed
	sudo mv main-imp/rc.local /etc/rc.local
fi

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

# Backup [.bashrc] if not exist already
if [ ! -f ~/.bashrc.b4imp ]; then cp ~/.bashrc ~/.bashrc.b4imp; fi

# Modify [.bashrc] to Stop [IMP] at ES Exit
bashrcCHECK=$(cat ~/.bashrc | grep -q 'pkill mpg123' ; echo $?)
if [ "$bashrcCHECK" == '0' ]; then
	# Replace [[ $(tty) == "/dev/tty1" ]] && pkill mpg123
	sudo sed -i s+'\[\[ $(tty) == \"/dev/tty1\" \]\] \&\& pkill mpg123'+'\[\[ $(tty) == \"/dev/tty1\" ]] \&\& bash /opt/retropie/configs/imp/stop.sh continue'+ ~/.bashrc
	# Replace pkill mpg123
	sudo sed -i s+'pkill mpg123'+'bash /opt/retropie/configs/imp/stop.sh continue'+ ~/.bashrc
else
	# Replace # RETROPIE PROFILE END - IF [.bashrc] did NOT Contain '# RETROPIE PROFILE END'  it will after this
	sudo sed -i s+'# RETROPIE PROFILE END'+'\[\[ $(tty) == "/dev/tty1" \]\] \&\& bash /opt/retropie/configs/imp/stop.sh continue'+ ~/.bashrc
	echo '# RETROPIE PROFILE END' >> ~/.bashrc
fi

# [IMP] might NOT have been added IF [.bashrc] did NOT Contain '# RETROPIE PROFILE END'  - Final check
IMPbashrcCHECK=$(cat ~/.bashrc | grep -q 'stop.sh continue' ; echo $?)
if [ "$IMPbashrcCHECK" == '1' ]; then
	# Replace # RETROPIE PROFILE END
	sudo sed -i s+'# RETROPIE PROFILE END'+'\[\[ $(tty) == "/dev/tty1" \]\] \&\& bash /opt/retropie/configs/imp/stop.sh continue'+ ~/.bashrc
	echo '# RETROPIE PROFILE END' >> ~/.bashrc
fi

# [es_systems.cfg] Modifications to allow [retropiemenu] to run Music files
# ------------ [Default] es_systems.cfg ------------ 
#    <extension>.rp .sh</extension>
#    <command>sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch %ROM% &lt;/dev/tty &gt;/dev/tty</command>

# ------------ [IMP] es_systems.cfg ------------ 
#    <extension>.rp .sh .mp3 .MP3 .pls .PLS .m3u .M3U </extension>
#    <command>bash /opt/retropie/configs/all/retropiemenu.sh %ROM%</command>      

# Add [IMP] to es_systems.cfg ETC
if [ -f /etc/emulationstation/es_systems.cfg ]; then	
	# Backup es_systems.cfg if not exist already
	if [ ! -f /etc/emulationstation/es_systems.cfg.b4imp ]; then sudo cp /etc/emulationstation/es_systems.cfg /etc/emulationstation/es_systems.cfg.b4imp 2>/dev/null; fi
	
	# Replace retropiemenu es_systems.cfg with [IMP]
	sudo sed -i s+"$EXTesSYS"+"$EXTesSYSimp"+ /etc/emulationstation/es_systems.cfg
	sudo sed -i s+"$CMDesSYS"+"$CMDesSYSimp"+ /etc/emulationstation/es_systems.cfg
	sudo sed -i s+"$CMDesSYShm"+"$CMDesSYSimp"+ /etc/emulationstation/es_systems.cfg
fi

# Add [IMP] to es_systems.cfg OPT
if [ -f /opt/retropie/configs/all/emulationstation/es_systems.cfg ]; then	
	# Backup es_systems.cfg if not exist already
	if [ ! -f /opt/retropie/configs/all/emulationstation/es_systems.cfg.b4imp ]; then sudo cp /opt/retropie/configs/all/emulationstation/es_systems.cfg /opt/retropie/configs/all/emulationstation/es_systems.cfg.b4imp 2>/dev/null; fi
	
	# Replace retropiemenu es_systems.cfg with [IMP]
	sudo sed -i s+"$EXTesSYS"+"$EXTesSYSimp"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg
	sudo sed -i s+"$CMDesSYS"+"$CMDesSYSimp"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg
	sudo sed -i s+"$CMDesSYShm"+"$CMDesSYSimp"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg
fi

# Add [IMP] to es_systems.cfg  HDDON/HDDOFF BAK
if [ -f /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk ]; then	
	# Backup es_systems.cfg if not exist already
	if [ ! -f /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk.b4imp ]; then sudo cp /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk.b4imp 2>/dev/null; fi
	
	# Replace retropiemenu es_systems.cfg with [IMP]
	sudo sed -i s+"$EXTesSYS"+"$EXTesSYSimp"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk
	sudo sed -i s+"$CMDesSYS"+"$CMDesSYSimp"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk
	sudo sed -i s+"$CMDesSYShm"+"$CMDesSYSimp"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk
fi

# Add [IMP] to es_systems.cfg HDDOFF
if [ -f ~/RetroPie/scripts/es_systems_HDDOFF.cfg ]; then	
	# Backup es_systems.cfg if not exist already
	if [ ! -f ~/RetroPie/scripts/es_systems_HDDOFF.cfg.b4imp ]; then sudo cp ~/RetroPie/scripts/es_systems_HDDOFF.cfg ~/RetroPie/scripts/es_systems_HDDOFF.cfg.b4imp 2>/dev/null; fi
	
	# Replace retropiemenu es_systems.cfg with [IMP]
	sudo sed -i s+"$EXTesSYS"+"$EXTesSYSimp"+ ~/RetroPie/scripts/es_systems_HDDOFF.cfg
	sudo sed -i s+"$CMDesSYS"+"$CMDesSYSimp"+ ~/RetroPie/scripts/es_systems_HDDOFF.cfg
	sudo sed -i s+"$CMDesSYShm"+"$CMDesSYSimp"+ ~/RetroPie/scripts/es_systems_HDDOFF.cfg
fi

# Add [IMP] to es_systems.cfg  HDDON
if [ -f ~/RetroPie/scripts/es_systems_HDDON.cfg ]; then	
	# Backup es_systems.cfg if not exist already
	if [ ! -f ~/RetroPie/scripts/es_systems_HDDON.cfg.b4imp ]; then sudo cp ~/RetroPie/scripts/es_systems_HDDON.cfg ~/RetroPie/scripts/es_systems_HDDON.cfg.b4imp 2>/dev/null; fi
	
	# Replace retropiemenu es_systems.cfg with [IMP]
	sudo sed -i s+"$EXTesSYS"+"$EXTesSYSimp"+ ~/RetroPie/scripts/es_systems_HDDON.cfg
	sudo sed -i s+"$CMDesSYS"+"$CMDesSYSimp"+ ~/RetroPie/scripts/es_systems_HDDON.cfg
	sudo sed -i s+"$CMDesSYShm"+"$CMDesSYSimp"+ ~/RetroPie/scripts/es_systems_HDDON.cfg
fi

# Copy the MAIN [retropiemenu.sh] Script now called by [retropiemenu] in modified es_systems.cfg
cp main-imp/configs-all/retropiemenu.sh /opt/retropie/configs/all/

# [gamelist.xml] Modifications for retropiemenu OPT
if [ -f /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml ]; then
	# Parse all lines Except </gameList>
	cat /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml | grep -v "</gameList>" > main-imp/gamelist.xml
	
	# [gamelist.xml] might NOT be properly formatted - Make it so
	if [ ! -f main-imp/gamelist.xml ]; then echo '<?xml version="1.0"?>' > main-imp/gamelist.xml; fi
	if [ $(cat main-imp/gamelist.xml | grep -q '<gameList>' ; echo $?) == '1' ]; then echo $'\n<gameList>' >> main-imp/gamelist.xml; fi
	
	# Rebuild retropiemenu gamelist.xml with [IMP]
	cat main-imp/gamelist.imp >> main-imp/gamelist.xml
	
	# Add Internet Radio Station Entries to gamelist.xml
	if [ ! "$installFLAG" == 'offline' ]; then cat main-imp/gamelist.streams >> main-imp/gamelist.xml; fi
	
	# Add SomaFM Entries to gamelist.xml
	if [ "$installFLAG" == 'somafm' ]; then cat main-imp/icons/somafm/gamelist.somafm >> main-imp/gamelist.xml; fi
	
	# Add the Finishing Line to gamelist.xml
	# echo $'\n</gameList>' >> main-imp/gamelist.xml
	echo '</gameList>' >> main-imp/gamelist.xml
	
	# Backup es_systems.cfg if not exist already
	if [ ! -f /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml.b4imp ]; then mv /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml.b4imp 2>/dev/null; fi
	
	# Replace retropiemenu gamelist.xml with [IMP]
	mv main-imp/gamelist.xml /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
	
	# Clean up tmp files
	rm main-imp/gamelist.xml > /dev/null 2>&1
fi

# [gamelist.xml] Modifications for retropiemenu rpMenu
if [ -f ~/RetroPie/retropiemenu/gamelist.xml ]; then	
	# Parse all lines Except </gameList>
	cat ~/RetroPie/retropiemenu/gamelist.xml | grep -v "</gameList>" > main-imp/gamelist.xml
	
	# [gamelist.xml] might NOT be properly formatted - Make it so
	if [ ! -f main-imp/gamelist.xml ]; then echo '<?xml version="1.0"?>' > main-imp/gamelist.xml; fi
	if [ $(cat main-imp/gamelist.xml | grep -q '<gameList>' ; echo $?) == '1' ]; then echo $'\n<gameList>' >> main-imp/gamelist.xml; fi
	
	# Rebuild retropiemenu gamelist.xml with [IMP]
	cat main-imp/gamelist.imp >> main-imp/gamelist.xml
	
	# Add Internet Radio Station Entries to gamelist.xml
	if [ ! "$installFLAG" == 'offline' ]; then cat main-imp/gamelist.streams >> main-imp/gamelist.xml; fi
	
	# Add SomaFM Entries to gamelist.xml
	if [ "$installFLAG" == 'somafm' ]; then cat main-imp/icons/somafm/gamelist.somafm >> main-imp/gamelist.xml; fi
	
	# Add the Finishing Line to gamelist.xml
	# echo $'\n</gameList>' >> main-imp/gamelist.xml
	echo '</gameList>' >> main-imp/gamelist.xml
	
	# Backup gamelist.xml if not exist already
	if [ ! -f ~/RetroPie/retropiemenu/gamelist.xml.b4imp ]; then mv ~/RetroPie/retropiemenu/gamelist.xml ~/RetroPie/retropiemenu/gamelist.xml.b4imp 2>/dev/null; fi
	
	# Replace retropiemenu gamelist.xml with [IMP]
	mv main-imp/gamelist.xml ~/RetroPie/retropiemenu/gamelist.xml
	
	# Clean up tmp files
	rm main-imp/gamelist.xml > /dev/null 2>&1
fi

# Copy icon files to retropiemenu
if [ ! -d ~/RetroPie/retropiemenu/icons/ ]; then mkdir ~/RetroPie/retropiemenu/icons; fi
cp main-imp/icons/imp/* ~/RetroPie/retropiemenu/icons/
if [ ! -f ~/RetroPie/retropiemenu/icons/backgroundmusic.png ]; then cp main-imp/icons/imp/impmusicdir.png ~/RetroPie/retropiemenu/icons/backgroundmusic.png; fi
if [ ! -f ~/RetroPie/retropiemenu/icons/jukebox.png ]; then cp main-imp/icons/imp/impmusicdir.png ~/RetroPie/retropiemenu/icons/jukebox.png; fi

# Put something in [musicDIR] [BGMdir]
if [ ! -f "$musicDIR/MMMenu.mp3" ]; then cp ~/RetroPie/retropiemenu/icons/impstartallm0.png "$musicDIR/MMMenu.mp3" > /dev/null 2>&1; fi
if [ ! -f "$BGMdir/A-SIDE/e1m1.mp3" ]; then cp ~/RetroPie/retropiemenu/icons/impstartbgmm0a.png "$musicDIR/bgm/A-SIDE/e1m1.mp3" > /dev/null 2>&1; fi
if [ ! -f "$BGMdir/B-SIDE/e1m2.mp3" ]; then cp ~/RetroPie/retropiemenu/icons/impstartbgmm0b.png "$musicDIR/bgm/B-SIDE/e1m2.mp3" > /dev/null 2>&1; fi
if [ ! -f "$BGMdir/startup.mp3" ]; then cp ~/RetroPie/retropiemenu/icons/impstartupm0.png "$BGMdir/startup.mp3" > /dev/null 2>&1; fi

# Replace [/home/pi] with current User [$homeDIR] in Playlist - This may Not be a pi
homeDIR=~/
sed -i s+'/home/pi/'+"$homeDIR"+ $IMPPlaylist/init
sed -i s+'/home/pi/'+"$homeDIR"+ $IMPPlaylist/abc
sed -i s+'/home/pi/'+"$homeDIR"+ $IMPPlaylist/shuffle
sed -i s+'/home/pi/'+"$homeDIR"+ $IMPPlaylist/current-track

# Symbolic Link to [../roms/music] NOT Shared in Samba
if [ -f /etc/samba/smb.conf ]; then
	# Backup [/etc/samba/smb.conf] if not exist already
	if [ ! -f /etc/samba/smb.conf.b4imp ]; then sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.b4imp 2>/dev/null; fi
	
	if [ ! "$(cat /etc/samba/smb.conf | grep -q "path = \"\/home\/$USER\/RetroPie\/retropiemenu\/imp\/music\"" ; echo $?)" == '0' ]; then
		# ADD Samba Share to [~/RetroPie/retropiemenu/imp/music]
		cat /etc/samba/smb.conf > /dev/shm/smb.conf
		echo '[music]' >> /dev/shm/smb.conf
		echo 'comment = music' >> /dev/shm/smb.conf
		echo "path = \"/home/$USER/RetroPie/retropiemenu/imp/music\"" >> /dev/shm/smb.conf
		echo 'writeable = yes' >> /dev/shm/smb.conf
		echo 'guest ok = yes' >> /dev/shm/smb.conf
		echo 'create mask = 0644' >> /dev/shm/smb.conf
		echo 'directory mask = 0755' >> /dev/shm/smb.conf
		echo "force user = $USER" >> /dev/shm/smb.conf
		sudo mv /dev/shm/smb.conf /etc/samba/smb.conf
		
		# Restart [SMB]
		# sudo systemctl restart smbd.service
	fi
fi

# Standard Install
if [ "$selectTYPE" == "$IMPstandard" ]; then
	# Copy the Main mpg123 Scripts to be Installed in [/opt/retropie/configs/all/]
	cp main-imp/configs-all/autostart.sh /opt/retropie/configs/all/
	cp main-imp/configs-all/runcommand-onstart.sh /opt/retropie/configs/all/
	cp main-imp/configs-all/runcommand-onend.sh /opt/retropie/configs/all/
	
	# If Found Replace Custom Scripts for Attract Mode and Pegasus in [retropiemenu]
	if [ -f ~/RetroPie/retropiemenu/attractmode.sh ] && [ -f main-imp/configs-all/attractmode.sh ]; then
		mv ~/RetroPie/retropiemenu/attractmode.sh ~/RetroPie/retropiemenu/attractmode.sh.b4imp
		cp main-imp/configs-all/attractmode.sh ~/RetroPie/retropiemenu/
	fi
	if [ -f ~/RetroPie/retropiemenu/emulationstation.sh ] && [ -f main-imp/configs-all/emulationstation.sh ]; then
		mv ~/RetroPie/retropiemenu/emulationstation.sh ~/RetroPie/retropiemenu/emulationstation.sh.b4imp
		cp main-imp/configs-all/emulationstation.sh ~/RetroPie/retropiemenu/
	fi
	if [ -f ~/RetroPie/retropiemenu/pegasus.sh ] && [ -f main-imp/configs-all/pegasus.sh ]; then
		mv ~/RetroPie/retropiemenu/pegasus.sh ~/RetroPie/retropiemenu/pegasus.sh.b4imp
		cp main-imp/configs-all/pegasus.sh ~/RetroPie/retropiemenu/
	fi
	# If Found Replace Custom Scripts for Attract Mode and Pegasus in [attractmodemenu]
	if [ -f ~/RetroPie/attractmodemenu/emulationstation.sh ] && [ -f main-imp/configs-all/emulationstation.sh ]; then
		mv ~/RetroPie/attractmodemenu/emulationstation.sh ~/RetroPie/attractmodemenu/emulationstation.sh.b4imp
		cp main-imp/configs-all/emulationstation.sh ~/RetroPie/attractmodemenu/
	fi
	if [ -f ~/RetroPie/attractmodemenu/pegasus.sh ] && [ -f main-imp/configs-all/pegasus.sh ]; then
		mv ~/RetroPie/attractmodemenu/pegasus.sh ~/RetroPie/attractmodemenu/pegasus.sh.b4imp
		cp main-imp/configs-all/pegasus.sh ~/RetroPie/attractmodemenu/
	fi
	
	# If Found Replace Custom Scripts for Attract Mode and Pegasus in [/opt/retropie/configs/all/]
	if [ -f /opt/retropie/configs/all/AM-start.sh ] && [ -f main-imp/configs-all/AM-start.sh ]; then
		mv /opt/retropie/configs/all/AM-start.sh /opt/retropie/configs/all/AM-start.sh.b4imp
		cp main-imp/configs-all/AM-start.sh /opt/retropie/configs/all/AM-start.sh
	fi
	if [ -f /opt/retropie/configs/all/ES-start.sh ] && [ -f main-imp/configs-all/ES-start.sh ]; then
		mv /opt/retropie/configs/all/ES-start.sh /opt/retropie/configs/all/ES-start.sh.b4imp
		cp main-imp/configs-all/ES-start.sh /opt/retropie/configs/all/ES-start.sh
	fi
	if [ -f /opt/retropie/configs/all/Pegasus-start.sh ] && [ -f main-imp/configs-all/Pegasus-start.sh ]; then
		mv /opt/retropie/configs/all/Pegasus-start.sh /opt/retropie/configs/all/Pegasus-start.sh.b4imp
		cp main-imp/configs-all/Pegasus-start.sh /opt/retropie/configs/all/Pegasus-start.sh
	fi
fi

# Supreme Build V2 RéGaLaD/WDG (PiZero 20180827) has a bug where RetroPie-Setup does Not have Joypad Support
if [ "$(cat ~/.bashrc | grep -q 'SuPreMe BuiLd PI 0/2/3/3+ V2' ; echo $?)" == '0' ]; then
	# Replace [IMP] Scripts that Require Joypad/Keyboard Input to Close in [retropiemenu]
	if [ -f main-imp/templates//Current Playlist.sh ]; then
		rm "$IMPMenuRP/Current Playlist.sh"
		cp main-imp/templates/Current\ Playlist.sh "$IMPMenuRP/Current Playlist.sh"
	fi
	if [ -f main-imp/templates/Current\ Settings.sh ]; then
		rm "$IMPMenuRP/Settings/Current Settings.sh"
		cp main-imp/templates/Current\ Settings.sh "$IMPMenuRP/Settings/Current Settings.sh"
	fi
	if [ -f main-imp/templates/HTTP\ Server\ Log.sh ]; then
		rm "$IMPMenuRP/Settings/HTTP Server Settings/HTTP Server Log.sh"
		cp main-imp/templates/HTTP\ Server\ Log.sh "$IMPMenuRP/Settings/HTTP Server Settings/HTTP Server Log.sh"
	fi
fi

# Custom Install
if [ "$selectTYPE" == "$IMPcustom" ]; then
	# If Found RUN [custom-imp.sh]
	if [ -f custom-imp/custom-imp.sh ]; then
	sudo chmod 755 custom-imp/custom-imp.sh
	bash custom-imp/custom-imp.sh
fi
	
	# Copy the Main mpg123 Scripts to be Installed in [/opt/retropie/configs/all/]
	cp custom-imp/autostart.sh /opt/retropie/configs/all/
	cp custom-imp/runcommand-onstart.sh /opt/retropie/configs/all/
	cp custom-imp/runcommand-onend.sh /opt/retropie/configs/all/
	
	# If Found Replace Custom Scripts that Require Joypad/Keyboard Input to Close in [retropiemenu]
	if [ -f custom-imp/Current\ Playlist.sh ]; then
		rm "$IMPMenuRP/Current Playlist.sh"
		cp custom-imp/Current\ Playlist.sh "$IMPMenuRP/Current Playlist.sh"
	fi
	if [ -f custom-imp/Current\ Settings.sh ]; then
		rm "$IMPMenuRP/Settings/Current Settings.sh"
		cp custom-imp/Current\ Settings.sh "$IMPMenuRP/Settings/Current Settings.sh"
	fi
	if [ -f custom-imp/HTTP\ Server\ Log.sh ]; then
		rm "$IMPMenuRP/Settings/HTTP Server Settings/HTTP Server Log.sh"
		cp custom-imp/HTTP\ Server\ Log.sh "$IMPMenuRP/Settings/HTTP Server Settings/HTTP Server Log.sh"
	fi
	
	# If Found Replace Custom Scripts for Attract Mode and Pegasus in [retropiemenu]
	if [ -f ~/RetroPie/retropiemenu/attractmode.sh ] && [ -f custom-imp/attractmode.sh ]; then
		mv ~/RetroPie/retropiemenu/attractmode.sh ~/RetroPie/retropiemenu/attractmode.sh.b4imp
		cp custom-imp/attractmode.sh ~/RetroPie/retropiemenu/
	fi
	if [ -f ~/RetroPie/retropiemenu/emulationstation.sh ] && [ -f custom-imp/emulationstation.sh ]; then
		mv ~/RetroPie/retropiemenu/emulationstation.sh ~/RetroPie/retropiemenu/emulationstation.sh.b4imp
		cp custom-imp/emulationstation.sh ~/RetroPie/retropiemenu/
	fi
	if [ -f ~/RetroPie/retropiemenu/pegasus.sh ] && [ -f custom-imp/pegasus.sh ]; then
		mv ~/RetroPie/retropiemenu/pegasus.sh ~/RetroPie/retropiemenu/pegasus.sh.b4imp
		cp custom-imp/pegasus.sh ~/RetroPie/retropiemenu/
	fi
	# If Found Replace Custom Scripts for Attract Mode and Pegasus in [attractmodemenu]
	if [ -f ~/RetroPie/attractmodemenu/emulationstation.sh ] && [ -f custom-imp/emulationstation.sh ]; then
		mv ~/RetroPie/attractmodemenu/emulationstation.sh ~/RetroPie/attractmodemenu/emulationstation.sh.b4imp
		cp custom-imp/emulationstation.sh ~/RetroPie/attractmodemenu/
	fi
	if [ -f ~/RetroPie/attractmodemenu/pegasus.sh ] && [ -f custom-imp/pegasus.sh ]; then
		mv ~/RetroPie/attractmodemenu/pegasus.sh ~/RetroPie/attractmodemenu/pegasus.sh.b4imp
		cp custom-imp/pegasus.sh ~/RetroPie/attractmodemenu/
	fi
	
	# If Found Replace Custom Scripts for Attract Mode and Pegasus in [/opt/retropie/configs/all/]
	if [ -f /opt/retropie/configs/all/AM-start.sh ] && [ -f custom-imp/AM-start.sh ]; then
		mv /opt/retropie/configs/all/AM-start.sh /opt/retropie/configs/all/AM-start.sh.b4imp
		cp custom-imp/AM-start.sh /opt/retropie/configs/all/AM-start.sh
	fi
	if [ -f /opt/retropie/configs/all/ES-start.sh ] && [ -f custom-imp/ES-start.sh ]; then
		mv /opt/retropie/configs/all/ES-start.sh /opt/retropie/configs/all/ES-start.sh.b4imp
		cp custom-imp/ES-start.sh /opt/retropie/configs/all/ES-start.sh
	fi
	if [ -f /opt/retropie/configs/all/Pegasus-start.sh ] && [ -f custom-imp/Pegasus-start.sh ]; then
		mv /opt/retropie/configs/all/Pegasus-start.sh /opt/retropie/configs/all/Pegasus-start.sh.b4imp
		cp custom-imp/Pegasus-start.sh /opt/retropie/configs/all/Pegasus-start.sh
	fi
fi

if [[ ! "$installFLAG" == 'offline' ]]; then
	# Create Streams Sub-directory
	if [ ! -d "$musicDIR/streams" ]; then mkdir "$musicDIR/streams"; fi
	
	# Get .M3U from SLAYRadio 202111
	if [ ! -d "$musicDIR/streams/SLAYRadio" ]; then mkdir "$musicDIR/streams/SLAYRadio"; fi
	if [ ! -f "$musicDIR/streams/SLAYRadio/slayradio.128.m3u" ]; then wget --no-check-certificate http://www.slayradio.org/tune_in.php/128kbps/slayradio.128.m3u -P "$musicDIR/streams/SLAYRadio"; fi

	# Copy SLAYRadio icon files to retropiemenu
	cp main-imp/icons/slayradio/slayradio.png ~/RetroPie/retropiemenu/icons/
	cp main-imp/icons/slayradio/slayradio-logo.png ~/RetroPie/retropiemenu/icons/

	# Get .PLS from MP3RadioFM 202111
	if [ ! -d "$musicDIR/streams/Mp3RadioFM" ]; then mkdir "$musicDIR/streams/Mp3RadioFM"; fi
	if [ ! -f "$musicDIR/streams/Mp3RadioFM/mp3radio.pls" ]; then wget --no-check-certificate "https://epsilon.shoutca.st/tunein/mp3radio.pls" -P "$musicDIR/streams/Mp3RadioFM"; fi

	# Copy MP3RadioFM icon files to retropiemenu
	cp main-imp/icons/mp3radiofm/mp3radiofm.png ~/RetroPie/retropiemenu/icons/
	
	# NightrideFM .pls (202202)
	if [ ! -d "$musicDIR/streams/NightrideFM" ]; then mkdir "$musicDIR/streams/NightrideFM"; fi
	if [ ! -f "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls" ]; then
		# Manually Create NightrideFM .pls (202202)
		echo '[playlist]' > "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'numberofentries=6' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'File1=http://stream.nightride.fm/nightride.mp3' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Title1=NightRide.FM Stream' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Length1=-1' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'File2=http://stream.nightride.fm/chillsynth.mp3' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Title2=NightRide.FM Stream' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Length1=-1' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'File3=http://stream.nightride.fm/spacesynth.mp3' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Title3=NightRide.FM Stream' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Length1=-1' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'File4=http://stream.nightride.fm/darksynth.mp3' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Title4=NightRide.FM Stream' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Length1=-1' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'File5=http://stream.nightride.fm/horrorsynth.mp3' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Title5=NightRide.FM Stream' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Length1=-1' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'File6=http://stream.nightride.fm/ebsm.mp3' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Title6=NightRide.FM Stream' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'Length1=-1' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
		echo 'version=2' >> "$musicDIR/streams/NightrideFM/NightrideFM-x6.pls"
	fi
	
	# Copy NightrideFM icon files to retropiemenu
	cp main-imp/icons/nightridefm/nightridefm.jpg ~/RetroPie/retropiemenu/icons/
	cp main-imp/icons/nightridefm/nightridefm.png ~/RetroPie/retropiemenu/icons/

	# Get .m3u from Rainwave.CC Stations (202202)
	# 1 Game # 2 OC Remix # 3 Covers # 4 ChipTune # 5 All
	if [ ! -f "$musicDIR/streams/RainwaveCC/1.mp3.m3u" ]; then wget --no-check-certificate https://rainwave.cc/tune_in/1.mp3.m3u -P "$musicDIR/streams/RainwaveCC"; fi
	if [ ! -f "$musicDIR/streams/RainwaveCC/2.mp3.m3u" ]; then wget --no-check-certificate https://rainwave.cc/tune_in/2.mp3.m3u -P "$musicDIR/streams/RainwaveCC"; fi
	if [ ! -f "$musicDIR/streams/RainwaveCC/3.mp3.m3u" ]; then wget --no-check-certificate https://rainwave.cc/tune_in/3.mp3.m3u -P "$musicDIR/streams/RainwaveCC"; fi
	if [ ! -f "$musicDIR/streams/RainwaveCC/4.mp3.m3u" ]; then wget --no-check-certificate https://rainwave.cc/tune_in/4.mp3.m3u -P "$musicDIR/streams/RainwaveCC"; fi
	if [ ! -f "$musicDIR/streams/RainwaveCC/5.mp3.m3u" ]; then wget --no-check-certificate https://rainwave.cc/tune_in/5.mp3.m3u -P "$musicDIR/streams/RainwaveCC"; fi
	
	# Copy Rainwave.CC icon files to retropiemenu
	cp main-imp/icons/rainwavecc/rainwave.png ~/RetroPie/retropiemenu/icons/
	cp main-imp/icons/rainwavecc/rainwavecc.png ~/RetroPie/retropiemenu/icons/
	
	# Get .PLS from DnBRadio 202203
	if [ ! -d "$musicDIR/streams/DnBRadio" ]; then mkdir "$musicDIR/streams/DnBRadio"; fi
	if [ ! -f "$musicDIR/streams/DnBRadio/hi.pls" ]; then wget --no-check-certificate https://dnbradio.com/hi.pls -P "$musicDIR/streams/DnBRadio"; fi

	# Copy DnBRadio icon files to retropiemenu
	cp main-imp/icons/dnbradio/dnbradio.png ~/RetroPie/retropiemenu/icons/
	cp main-imp/icons/dnbradio/dnbradio0.png ~/RetroPie/retropiemenu/icons/
fi

if [ "$installFLAG" == 'somafm' ]; then
	# Get .PLS from SomaFM 202112
	# [IMP] has been Listening to SomaFM since 2006 (NO AFFILIATION)
	# Please DONATE if you ENJOY SomaFM
	if [ ! -d "$musicDIR/streams/SomaFM" ]; then mkdir "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/7soul.pls" ]; then wget --no-check-certificate https://somafm.com/7soul.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/beatblender.pls" ]; then wget --no-check-certificate https://somafm.com/beatblender.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/bootliquor.pls" ]; then wget --no-check-certificate https://somafm.com/bootliquor.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/brfm.pls" ]; then wget --no-check-certificate https://somafm.com/brfm.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/covers.pls" ]; then wget --no-check-certificate https://somafm.com/covers.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/deepspaceone.pls" ]; then wget --no-check-certificate https://somafm.com/deepspaceone.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/defcon.pls" ]; then wget --no-check-certificate https://somafm.com/defcon.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/digitalis.pls" ]; then wget --no-check-certificate https://somafm.com/digitalis.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/dronezone.pls" ]; then wget --no-check-certificate https://somafm.com/dronezone.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/dubstep.pls" ]; then wget --no-check-certificate https://somafm.com/dubstep.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/fluid.pls" ]; then wget --no-check-certificate https://somafm.com/fluid.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/folkfwd.pls" ]; then wget --no-check-certificate https://somafm.com/folkfwd.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/groovesalad.pls" ]; then wget --no-check-certificate https://somafm.com/groovesalad.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/gsclassic.pls" ]; then wget --no-check-certificate https://somafm.com/gsclassic.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/illstreet.pls" ]; then wget --no-check-certificate https://somafm.com/illstreet.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/indiepop.pls" ]; then wget --no-check-certificate https://somafm.com/indiepop.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/live.pls" ]; then wget --no-check-certificate https://somafm.com/live.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/lush.pls" ]; then wget --no-check-certificate https://somafm.com/lush.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/metal.pls" ]; then wget --no-check-certificate https://somafm.com/metal.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/missioncontrol.pls" ]; then wget --no-check-certificate https://somafm.com/missioncontrol.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/n5md.pls" ]; then wget --no-check-certificate https://somafm.com/n5md.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/poptron.pls" ]; then wget --no-check-certificate https://somafm.com/poptron.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/reggae.pls" ]; then wget --no-check-certificate https://somafm.com/reggae.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/secretagent.pls" ]; then wget --no-check-certificate https://somafm.com/secretagent.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/seventies.pls" ]; then wget --no-check-certificate https://somafm.com/seventies.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/sonicuniverse.pls" ]; then wget --no-check-certificate https://somafm.com/sonicuniverse.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/spacestation.pls" ]; then wget --no-check-certificate https://somafm.com/spacestation.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/suburbsofgoa.pls" ]; then wget --no-check-certificate https://somafm.com/suburbsofgoa.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/synphaera.pls" ]; then wget --no-check-certificate https://somafm.com/synphaera.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/thetrip.pls" ]; then wget --no-check-certificate https://somafm.com/thetrip.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/thistle.pls" ]; then wget --no-check-certificate https://somafm.com/thistle.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/u80s.pls" ]; then wget --no-check-certificate https://somafm.com/u80s.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/vaporwaves.pls" ]; then wget --no-check-certificate https://somafm.com/vaporwaves.pls -P "$musicDIR/streams/SomaFM"; fi
	# Seasonal SomaFM
	if [ ! -f "$musicDIR/streams/SomaFM/christmas.pls" ]; then wget --no-check-certificate https://somafm.com/christmas.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/xmasrocks.pls" ]; then wget --no-check-certificate https://somafm.com/xmasrocks.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/jollysoul.pls" ]; then wget --no-check-certificate https://somafm.com/jollysoul.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/xmasinfrisko.pls" ]; then wget --no-check-certificate https://somafm.com/xmasinfrisko.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$musicDIR/streams/SomaFM/specials.pls" ]; then wget --no-check-certificate https://somafm.com/specials.pls -P "$musicDIR/streams/SomaFM"; fi
	if [ ! -f "$IMP/somafm-specials.sh" ]; then
		cp main-imp/icons/somafm/somafm-specials.sh $IMP/somafm-specials.sh
		sudo chmod 755 $IMP/somafm-specials.sh
		bash $IMP/somafm-specials.sh
	fi
	
	# Copy SomaFM icon files to retropiemenu
	cp main-imp/icons/somafm/*.png ~/RetroPie/retropiemenu/icons/
	cp main-imp/icons/somafm/*.jpg ~/RetroPie/retropiemenu/icons/
fi

impFINISH
}

impUNINSTALL()
{
tput reset

# Check if IMP Installed
if [ ! -d "$IMP" ]; then
	dialog --no-collapse --title "   * [IMP] INSTALL NOT DETECTED *   " --ok-label Back --msgbox "$impLOGO $impFILEREF"  25 75
	mainMENU
fi

# Stop [IMP]
bash $IMP/stop.sh
pkill -KILL mpg123

# Uninstall mpg123
# sudo apt-get -y remove mpg123

# Turn Off HTTP Server - Cleans up $HTTPFolder/favicon.ico
bash "$IMPMenuRP/Settings/HTTP Server Settings/HTTP Server [Off].sh"

# Restore [smb.conf] if Backup is found
if [ -f /etc/samba/smb.conf.b4imp ]; then
    sudo mv /etc/samba/smb.conf.b4imp /etc/samba/smb.conf
	# Restart [SMB]
	# sudo systemctl restart smbd.service
fi

# Restore autostart.sh if Backup is found
if [ -f /opt/retropie/configs/all/autostart.sh.b4imp ]; then
    mv /opt/retropie/configs/all/autostart.sh.b4imp /opt/retropie/configs/all/autostart.sh
fi
if [ ! -f /opt/retropie/configs/all/autostart.sh ]; then
	# ?Create autostart.sh from scratch if NOT found?
	echo "while pgrep omxplayer >/dev/null; do sleep 1; done" > /opt/retropie/configs/all/autostart.sh
	echo "emulationstation #auto" >> /opt/retropie/configs/all/autostart.sh
fi

# Restore [rc.local] if Backup is found
if [ -f /etc/rc.local.b4imp ]; then
    sudo mv /etc/rc.local.b4imp /etc/rc.local
fi

# Remove [IMP] to the Auto-start ES/Kodi on Boot Script [~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh]
sed -i s+"$impKODI"+"$rpsKODI"+ $rpsKODIautostart
sed -i s+"$impKODIsa"+"$rpsKODIsa"+ $rpsKODIautostart
sed -i s+"$impKODIes"+"$rpsKODIes"+ $rpsKODIautostart

# Restore runcommand-onstart.sh if Backup is found
if [ -f /opt/retropie/configs/all/runcommand-onstart.sh.b4imp ]; then
    mv /opt/retropie/configs/all/runcommand-onstart.sh.b4imp /opt/retropie/configs/all/runcommand-onstart.sh
else
    # Remove runcommand-onstart.sh if Backup NOT found
	rm /opt/retropie/configs/all/runcommand-onstart.sh
fi

# Restore runcommand-onend.sh if Backup is found
if [ -f /opt/retropie/configs/all/runcommand-onend.sh.b4imp ]; then
    mv /opt/retropie/configs/all/runcommand-onend.sh.b4imp /opt/retropie/configs/all/runcommand-onend.sh
else
    # Remove runcommand-onend.sh if Backup NOT found
	rm /opt/retropie/configs/all/runcommand-onend.sh
fi

# Restore gamelist.xml OPT if Backup is found
if [ -f /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml.b4imp ]; then
    mv /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml.b4imp /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
fi

# Restore gamelist.xml retropiemenu if Backup is found
if [ -f ~/RetroPie/retropiemenu/gamelist.xml.b4imp ]; then
    mv ~/RetroPie/retropiemenu/gamelist.xml.b4imp ~/RetroPie/retropiemenu/gamelist.xml
fi

# Remove [IMP] from es_systems.cfg ETC
if [ -f /etc/emulationstation/es_systems.cfg ]; then
	sudo sed -i s+"$EXTesSYSimp"+"$EXTesSYS"+ /etc/emulationstation/es_systems.cfg
	sudo sed -i s+"$CMDesSYSimp"+"$CMDesSYS"+ /etc/emulationstation/es_systems.cfg
	sudo sed -i s+"$CMDesSYSimp"+"$CMDesSYShm"+ /etc/emulationstation/es_systems.cfg
fi

# Remove [IMP] from es_systems.cfg OPT
if [ -f /opt/retropie/configs/all/emulationstation/es_systems.cfg ]; then
	sudo sed -i s+"$EXTesSYSimp"+"$EXTesSYS"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg
	sudo sed -i s+"$CMDesSYSimp"+"$CMDesSYS"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg
	sudo sed -i s+"$CMDesSYSimp"+"$CMDesSYShm"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg
fi

# Remove [IMP] from es_systems.cfg  HDDON/HDDOFF BAK
if [ -f /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk ]; then
	sudo sed -i s+"$EXTesSYSimp"+"$EXTesSYS"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk
	sudo sed -i s+"$CMDesSYSimp"+"$CMDesSYS"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk
	sudo sed -i s+"$CMDesSYSimp"+"$CMDesSYShm"+ /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk
fi

# Remove [IMP] from es_systems.cfg HDDOFF
if [ -f ~/RetroPie/scripts/es_systems_HDDOFF.cfg ]; then
	sudo sed -i s+"$EXTesSYSimp"+"$EXTesSYS"+ ~/RetroPie/scripts/es_systems_HDDOFF.cfg
	sudo sed -i s+"$CMDesSYSimp"+"$CMDesSYS"+ ~/RetroPie/scripts/es_systems_HDDOFF.cfg
	sudo sed -i s+"$CMDesSYSimp"+"$CMDesSYShm"+ ~/RetroPie/scripts/es_systems_HDDOFF.cfg
fi

# Remove [IMP] from es_systems.cfg  HDDON
if [ -f ~/RetroPie/scripts/es_systems_HDDON.cfg ]; then
	sudo sed -i s+"$EXTesSYSimp"+"$EXTesSYS"+ ~/RetroPie/scripts/es_systems_HDDON.cfg
	sudo sed -i s+"$CMDesSYSimp"+"$CMDesSYS"+ ~/RetroPie/scripts/es_systems_HDDON.cfg
	sudo sed -i s+"$CMDesSYSimp"+"$CMDesSYShm"+ ~/RetroPie/scripts/es_systems_HDDON.cfg
fi

# Restore 0ther Custom Scripts
if [ -f ~/RetroPie/retropiemenu/attractmode.sh.b4imp ]; then mv ~/RetroPie/retropiemenu/attractmode.sh.b4imp ~/RetroPie/retropiemenu/attractmode.sh; fi
if [ -f ~/RetroPie/retropiemenu/emulationstation.sh.b4imp ]; then mv ~/RetroPie/retropiemenu/emulationstation.sh.b4imp ~/RetroPie/retropiemenu/emulationstation.sh; fi
if [ -f ~/RetroPie/retropiemenu/pegasus.sh.b4imp ]; then mv ~/RetroPie/retropiemenu/pegasus.sh.b4imp ~/RetroPie/retropiemenu/pegasus.sh; fi
if [ -f ~/RetroPie/attractmodemenu/emulationstation.sh.b4imp ]; then mv ~/RetroPie/attractmodemenu/emulationstation.sh.b4imp ~/RetroPie/attractmodemenu/emulationstation.sh; fi
if [ -f ~/RetroPie/attractmodemenu/pegasus.sh.b4imp ]; then mv ~/RetroPie/attractmodemenu/pegasus.sh.b4imp ~/RetroPie/attractmodemenu/pegasus.sh; fi
if [ -f /opt/retropie/configs/all/AM-start.sh.b4imp ]; then mv /opt/retropie/configs/all/AM-start.sh.b4imp /opt/retropie/configs/all/AM-start.sh; fi
if [ -f /opt/retropie/configs/all/ES-start.sh.b4imp ]; then mv /opt/retropie/configs/all/ES-start.sh.b4imp /opt/retropie/configs/all/ES-start.sh; fi
if [ -f /opt/retropie/configs/all/Pegasus-start.sh.b4imp ]; then mv /opt/retropie/configs/all/Pegasus-start.sh.b4imp /opt/retropie/configs/all/Pegasus-start.sh; fi

# Remove the [retropiemenu.sh] Script Associated with es_systems.cfg
rm /opt/retropie/configs/all/retropiemenu.sh

# Remove Leftover Files from Standard Install
if [ -f main-imp/configs-all/autostart.sh ]; then rm main-imp/configs-all/autostart.sh; fi
if [ -f main-imp/configs-all/runcommand-onend.sh ]; then rm main-imp/configs-all/runcommand-onend.sh; fi
if [ -f main-imp/configs-all/runcommand-onstart.sh ]; then rm main-imp/configs-all/runcommand-onstart.sh; fi
if [ -f main-imp/configs-all/attractmode.sh ]; then rm main-imp/configs-all/attractmode.sh; fi
if [ -f main-imp/configs-all/emulationstation.sh ]; then rm main-imp/configs-all/emulationstation.sh; fi
if [ -f main-imp/configs-all/pegasus.sh ]; then rm main-imp/configs-all/pegasus.sh; fi
if [ -f main-imp/configs-all/AM-start.sh ]; then rm main-imp/configs-all/AM-start.sh; fi
if [ -f main-imp/configs-all/ES-start.sh ]; then rm main-imp/configs-all/ES-start.sh; fi
if [ -f main-imp/configs-all/Pegasus-start.sh ]; then rm main-imp/configs-all/Pegasus-start.sh; fi

# Restore [.bashrc]
if [ -f ~/.bashrc.b4imp ]; then mv ~/.bashrc.b4imp ~/.bashrc; fi

# Remove symbolic link to music from retropiemenu
unlink $musicROMS
mv $musicDIR $musicROMS

# Remove [IMP] files from retropiemenu
rm $IMPMenuRP/*.sh
rm $IMPMenuRP/Settings/*.sh
rm $IMPMenuRP/Settings/BGM\ Settings/*.sh
rm $IMPMenuRP/Settings/Game\ Settings/*.sh
rm $IMPMenuRP/Settings/HTTP\ Server\ Settings/*.sh
rm $IMPMenuRP/Settings/Randomizer\ Settings/*.sh
rm $IMPMenuRP/Settings/Startup\ Settings/*.sh
rm $IMPMenuRP/Volume/*.sh

# Remove [IMP] Directories from retropiemenu
# rm -R $IMPMenuRP
rm -d $IMPMenuRP/Settings/BGM\ Settings/
rm -d $IMPMenuRP/Settings/Game\ Settings/
rm -d $IMPMenuRP/Settings/HTTP\ Server\ Settings/
rm -d $IMPMenuRP/Settings/Randomizer\ Settings/
rm -d $IMPMenuRP/Settings/Startup\ Settings/
rm -d $IMPMenuRP/Settings/
rm -d $IMPMenuRP/Volume/
rm -d $IMPMenuRP/

# Remove [IMP] files from /opt/retropie/configs/all
rm $IMP/playlist/* 2>/dev/null
rm $IMP/settings/* 2>/dev/null
rm $IMP/* 2>/dev/null

# Remove [IMP] Directories from /opt/retropie/configs/all
# rm -R $IMP
rm -d $IMP/playlist/ 2>/dev/null
rm -d $IMP/settings/ 2>/dev/null
rm -d $IMP/ 2>/dev/null

# Remove [IMP] Icons from retropiemenu
rm ~/RetroPie/retropiemenu/icons/imp.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impbgmdira.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impbgmdirb.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impbgmdirs.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imphttplog.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imphttpon.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imphttpoff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impinfiniteoff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impinfiniteon.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impliteoff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impliteon.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impmusicdir.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impnext.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imppause.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impplay.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impplaylist.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impprevious.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impprevious0ff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impprevious0n.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imprandomizerall.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imprandomizeralla0b0.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imprandomizeralla0b1.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imprandomizeralla1b0.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imprandomizeralla1b1.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imprandomizerbgm.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/imprandomizeroff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingadjust.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingbgmaoff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingbgmaon.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingbgmboff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingbgmbon.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingfadeoff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingfadeon.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingmusicoff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingmusicon.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingshufflebootoff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingshufflebooton.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingoff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingon.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettings.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingscurrent.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingstartupsongoff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impsettingstartupsongon.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impshuffleoff.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impshuffleon.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartall.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartallm0.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartalla0b0.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartalla1b0.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartalla0b1.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartalla1b1.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartupm0.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartupsong.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartbgm.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartbgmm0a.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstartbgmm0b.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impstop.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume05.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume10.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume20.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume30.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume40.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume50.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume60.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume70.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume80.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume90.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/impvolume100.png 2>/dev/null

# Remove SomaFM
rm $musicROMS/SomaFM/*.pls 2>/dev/null
rm -d $musicROMS/SomaFM 2>/dev/null
rm $musicROMS/streams/SomaFM/*.pls 2>/dev/null
rm -d $musicROMS/streams/SomaFM 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/somafm.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/7soul-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/beatblender-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/bootliquor-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/brfm-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/covers-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/deepspaceone-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/defcon-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/defcon400.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/digitalis-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/dronezone-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/dubstep-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/fluid-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/folkfwd-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/groovesalad-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/gsclassic400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/illstreet-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/indiepop-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/live-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/lush-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/metal-400.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/missioncontrol-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/n5md-400.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/reggae400.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/poptron-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/secretagent-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/seventies400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/sonicuniverse-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/spacestation-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/suburbsofgoa-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/synphaera400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/thetrip-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/thistle-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/u80s-400.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/vaporwaves-400.jpg 2>/dev/null
# Seasonal SomaFM
rm ~/RetroPie/retropiemenu/icons/christmas-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/jollysoul-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/xmasinfrisko-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/xmasrocks-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/specials-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/deptstorechristmas-400.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/doomed-400.jpg 2>/dev/null

# Remove SLAYRadio
rm $musicROMS/SLAYRadio/*.m3u 2>/dev/null
rm -d $musicROMS/SLAYRadio 2>/dev/null
rm $musicROMS/streams/SLAYRadio/*.m3u 2>/dev/null
rm -d $musicROMS/streams/SLAYRadio 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/slayradio.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/slayradio-logo.png 2>/dev/null

# Remove MP3RadioFM
rm $musicROMS/Mp3RadioFM/*.pls 2>/dev/null
rm -d $musicROMS/Mp3RadioFM 2>/dev/null
rm $musicROMS/streams/Mp3RadioFM/*.pls 2>/dev/null
rm -d $musicROMS/streams/Mp3RadioFM 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/mp3radiofm.png 2>/dev/null

# Remove NightrideFM
rm $musicROMS/NightrideFM/*.pls 2>/dev/null
rm -d $musicROMS/NightrideFM 2>/dev/null
rm $musicROMS/streams/NightrideFM/*.pls 2>/dev/null
rm -d $musicROMS/streams/NightrideFM 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/nightridefm.jpg 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/nightridefm.png 2>/dev/null

# Remove RainwaveCC
rm $musicROMS/RainwaveCC/*.m3u 2>/dev/null
rm -d $musicROMS/RainwaveCC 2>/dev/null
rm $musicROMS/streams/RainwaveCC/*.m3u 2>/dev/null
rm -d $musicROMS/streams/RainwaveCC 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/rainwave.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/rainwavecc.png 2>/dev/null

# Remove DnBRadio
rm $musicROMS/DnBRadio/*.pls 2>/dev/null
rm -d $musicROMS/DnBRadio 2>/dev/null
rm $musicROMS/streams/DnBRadio/*.pls 2>/dev/null
rm -d $musicROMS/streams/DnBRadio 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/dnbradio.png 2>/dev/null
rm ~/RetroPie/retropiemenu/icons/dnbradio0.png 2>/dev/null

# Remove Streams
rm -d $musicROMS/streams 2>/dev/null

# Clean up 0ther BGM DIRs 0nly if they are Symbolic Links
if [ -d "$musicROMS/_bgm" ]; then
	if [ ! $(readlink "$musicROMS/_bgm") == '' ]; then rm "$musicROMS/_bgm";	fi
fi

if [ -d "$musicROMS/_backgroundmusic" ]; then
	if [ ! $(readlink "$musicROMS/_backgroundmusic") == '' ]; then rm "$musicROMS/_backgroundmusic"; fi
fi

if [ -d "$musicROMS/_jukebox_mp3" ]; then
	if [ ! $(readlink "$musicROMS/_jukebox_mp3") == '' ]; then rm "$musicROMS/_jukebox_mp3"; fi
fi

if [ -d "$musicROMS/_AttractModeSounds" ]; then
	if [ ! $(readlink "$musicROMS/_AttractModeSounds") == '' ]; then rm "$musicROMS/_AttractModeSounds"; fi
fi

# Enable 0ther BGMs Indiscriminately
# Restore Various backgroundmusic scripts
if [ -f ~/RetroPie/retropiemenu/backgroundmusic.sh.b4imp ]; then mv ~/RetroPie/retropiemenu/backgroundmusic.sh.b4imp ~/RetroPie/retropiemenu/backgroundmusic.sh; fi
if [ -f ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh.b4imp ]; then mv ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh.b4imp ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh; fi
if [ -f ~/RetroPie/retropiemenu/audiotools/backgroundmusic.sh.b4imp ]; then mv ~/RetroPie/retropiemenu/audiotools/backgroundmusic.sh.b4imp ~/RetroPie/retropiemenu/audiotools/backgroundmusic.sh; fi

# Enable Livewire
if [ -f ~/.DisableMusic ]; then rm ~/.DisableMusic; fi
if [ -f /home/pi/RetroPie/retropiemenu/bgm-mute.sh.b4imp ]; then mv /home/pi/RetroPie/retropiemenu/bgm-mute.sh.b4imp /home/pi/RetroPie/retropiemenu/bgm-mute.sh; fi

# Enable BGM Naprosnia
# if [ -f ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh.b4imp ]; then mv ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh.b4imp ~/RetroPie/retropiemenu/Audiotools/backgroundmusic.sh 2>/dev/null; fi
if [ -f ~/RetroPie/retropiemenu/RetroPie-BGM-Player.sh.b4imp ]; then mv ~/RetroPie/retropiemenu/RetroPie-BGM-Player.sh.b4imp ~/RetroPie/retropiemenu/RetroPie-BGM-Player.sh 2>/dev/null; fi
if [ -f ~/RetroPie-BGM-Player/bgm_system.sh ]; then
	bash ~/RetroPie-BGM-Player/bgm_system.sh -setsetting bgm_toggle 1
	bash ~/RetroPie-BGM-Player/bgm_system.sh -i
fi

# Enable BGM Rydra
sudo systemctl enable bgm > /dev/null 2>&1
sudo systemctl start bgm > /dev/null 2>&1
# sudo systemctl daemon-reload > /dev/null 2>&1

# Enable BGM 0fficialPhilcomm
sudo systemctl enable retropie_music > /dev/null 2>&1
sudo systemctl start retropie_music > /dev/null 2>&1
# sudo systemctl daemon-reload > /dev/null 2>&1

# Final daemon-reload after Enable 0ther BGMs
sudo systemctl daemon-reload > /dev/null 2>&1

impFINISH
}

impFINISH()
{
# Finished Install - Confirm Reboot
confREBOOT=$(dialog --stdout --no-collapse --title "*INSTALL* $selectTYPE *COMPLETE*" \
	--ok-label OK --cancel-label EXIT \
	--menu "$impLOGO $impFINISHREF" 25 75 20 \
	1 "REBOOT" \
	2 "Back to Menu" \
	3 "EXIT")
# Reboot Confirm - Otherwise Exit
if [ "$confREBOOT" == '1' ]; then tput reset && sudo reboot; fi
if [ "$confREBOOT" == '2' ]; then mainMENU; fi

tput reset
exit 0
}

mpg123MENU()
{
# Identify Current version of [mpg123]
# Expected Result: bash: /usr/bin/mpg123: No such file or directory
# Expected Result: Command 'mpg123' not found, did you mean:
# Expected Result: mpg123 1.25.10
mpg123VER=$(mpg123 --version)
if [[ ! "$mpg123VER" == "mpg123 1."* ]]; then mpg123VER="mpg123-?.??.??"; fi

# Confirm mpg123 Manual Install
confMPG123=$(dialog --stdout --no-collapse --title "  Select mpg123 Install Method  [Current Version Detected: $mpg123VER]  " \
	--ok-label OK --cancel-label Back \
	--menu "$mpg123FILEREF " 25 75 20 \
	1 " [apt-get install] mpg123  [Recommended]" \
	2 " [make install] mpg123-1.29.3" \
	3 " [make install] mpg123-1.29.3  [Offline]" \
	4 " [make install] mpg123-1.25.10" \
	5 " [make install] mpg123-1.25.10 [Offline]" \
	6 " [make install] mpg123-1.20.1" \
	7 " [make install] mpg123-1.20.1  [Offline]" \
	8 " UNINSTALL mpg123-1.2.x.y" \
	9 " [KILL] ES/Pegasus/AM [Recommended before make install]")
	
# mpg123 Manual Uninstall Confirmed - Otherwise Back to Main Menu
if [ "$confMPG123" == '8' ]; then
	confUNmpg123=$(dialog --stdout --no-collapse --title "               UNINSTALL [mpg123-1.2.x.y]               " \
		--ok-label OK --cancel-label Back \
		--menu "                          ? ARE YOU SURE ?             " 25 75 20 \
		1 "><  UNINSTALL [mpg123-1.2.x.y]  ><" \
		2 "Back to Menu")
	# Uninstall Confirmed - Otherwise Back to Main Menu
	if [ "$confUNmpg123" == '1' ]; then mpg123UNINSTALL; fi
	mpg123MENU
fi

# mpg123 Manual Install Confirmed - Otherwise Back to Main Menu
if [ ! "$confMPG123" == '' ]; then
	if [ "$confMPG123" == '1' ]; then mpg123SELECT='[apt-get install] mpg123'; fi
	if [ "$confMPG123" == '2' ]; then mpg123SELECT='[make install] mpg123-1.29.3'; fi
	if [ "$confMPG123" == '3' ]; then mpg123SELECT='[make install] mpg123-1.29.3  [Offline]' ; fi
	if [ "$confMPG123" == '4' ]; then mpg123SELECT='[make install] mpg123-1.25.10'; fi
	if [ "$confMPG123" == '5' ]; then mpg123SELECT='[make install] mpg123-1.25.10 [Offline]'; fi
	if [ "$confMPG123" == '6' ]; then mpg123SELECT='[make install] mpg123-1.20.1'; fi
	if [ "$confMPG123" == '7' ]; then mpg123SELECT='[make install] mpg123-1.20.1  [Offline]'; fi
	if [ "$confMPG123" == '9' ]; then
		kill $(ps -eaf | grep "emulationstation" | awk '{print $2}')  > /dev/null 2>&1
		kill $(ps -eaf | grep "pegasus-fe" | awk '{print $2}')  > /dev/null 2>&1
		kill $(ps -eaf | grep "attract" | awk '{print $2}')  > /dev/null 2>&1
		mpg123MENU
	fi
	
	confINmpg123=$(dialog --stdout --no-collapse --title "               CONFIRM $mpg123SELECT               " \
		--ok-label OK --cancel-label Back \
		--menu "  ? ARE YOU SURE ?  This will REMOVE Any [mpg123] Currently INSTALLED  " 25 75 20 \
		1 "><  $mpg123SELECT  ><" \
		2 "Back to Menu")
	
	# Ininstall Confirmed - Otherwise Back to Main Menu
	if [ "$confINmpg123" == '1' ]; then mpg123INSTALL; fi
	mpg123MENU
fi

mainMENU
}

mpg123INSTALL()
{
tput reset

# Stop mpg123 - Stop [IMP] if found
if [ -f /opt/retropie/configs/imp/stop.sh ]; then bash /opt/retropie/configs/imp/stop.sh; fi
pkill -STOP mpg123  > /dev/null 2>&1
pkill -KILL mpg123 > /dev/null 2>&1

# [apt-get remove] any Current Version if Found
sudo apt-get remove mpg123 -y

# [make uninstall] 0ther Versions of mpg123 Installed by [IMP] if Found 
if [ -f ~/imp/mpg123-1.29.3.tar.bz2 ]; then rm ~/imp/mpg123-1.29.3.tar.bz2; fi
if [ -d ~/imp/mpg123-1.29.3 ]; then
	cd ~/imp/mpg123-1.29.3
	sudo make uninstall
	cd ~/imp
	sudo rm ~/imp/mpg123-1.29.3 -R
fi

if [ -f ~/imp/mpg123-1.25.10.tar.bz2 ]; then rm ~/imp/mpg123-1.25.10.tar.bz2; fi
if [ -d ~/imp/mpg123-1.25.10 ]; then
	cd ~/imp/mpg123-1.25.10
	sudo make uninstall
	cd ~/imp
	sudo rm ~/imp/mpg123-1.25.10 -R
fi

if [ -f ~/imp/mpg123-1.20.1.tar.bz2 ]; then rm ~/imp/mpg123-1.20.1.tar.bz2; fi
if [ -d ~/imp/mpg123-1.20.1 ]; then
	cd ~/imp/mpg123-1.20.1
	sudo make uninstall
	cd ~/imp
	sudo rm ~/imp/mpg123-1.20.1 -R
fi

if [ "$confMPG123" == '1' ]; then
	# mpg123 Stable
	sudo apt-get install mpg123 -y
fi

if [ "$confMPG123" == '2' ]; then
	# mpg123 v1.29.3 2021-09-05
	wget --no-check-certificate https://sourceforge.net/projects/mpg123/files/mpg123/1.29.3/mpg123-1.29.3.tar.bz2 -P ~/imp
	# wget --no-check-certificate https://sourceforge.net/projects/mpg123/files/mpg123/1.29.3/mpg123-1.29.3.tar.bz2.sig ~/imp
	tar -xvf mpg123-1.29.3.tar.bz2
	cd ~/imp/mpg123-1.29.3
	sudo ./configure --prefix=/usr --with-default-audio=alsa --disable-shared && make -j4
	sudo make install
	rm ~/imp/mpg123-1.29.3.tar.bz2
fi

if [ "$confMPG123" == '3' ]; then
	# Check for the mpg123 Offline Installation File
	if [ ! -f main-imp/offline/mpg123-1.29.3.tar.bz2]; then
	dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [mpg123-1.29.3.tar.bz2] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $mpg123FILEREF"  25 75
	mainMENU
	fi
	
	# mpg123 v1.29.3 2021-12-11 [Offline]
	cp ~/imp/main-imp/offline/mpg123-1.29.3.tar.bz2 ~/imp
	tar -xvf mpg123-1.29.3.tar.bz2
	cd ~/imp/mpg123-1.29.3
	sudo ./configure --prefix=/usr --with-default-audio=alsa --disable-shared && make -j4
	sudo make install
	rm ~/imp/mpg123-1.29.3.tar.bz2
fi

if [ "$confMPG123" == '4' ]; then
	# mpg123 v1.25.10 2018-03-05
	wget --no-check-certificate https://sourceforge.net/projects/mpg123/files/mpg123/1.25.10/mpg123-1.25.10.tar.bz2 -P ~/imp
	# wget --no-check-certificate https://sourceforge.net/projects/mpg123/files/mpg123/1.25.10/mpg123-1.25.10.tar.bz2.sig -P ~/imp
	tar -xvf mpg123-1.25.10.tar.bz2
	cd ~/imp/mpg123-1.25.10
	sudo ./configure --prefix=/usr --with-default-audio=alsa --disable-shared && make -j4
	sudo make install
	rm ~/imp/mpg123-1.25.10.tar.bz2
fi

if [ "$confMPG123" == '5' ]; then
	# Check for the mpg123 Offline Installation File
	if [ ! -f main-imp/offline/mpg123-1.25.10.tar.bz2]; then
	dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [mpg123-1.25.10.tar.bz2] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $mpg123FILEREF"  25 75
	mainMENU
	fi
	
	# mpg123 v1.25.10 2018-03-05 [Offline]
	cp ~/imp/main-imp/offline/mpg123-1.25.10.tar.bz2 ~/imp
	tar -xvf mpg123-1.25.10.tar.bz2
	cd ~/imp/mpg123-1.25.10
	sudo ./configure --prefix=/usr --with-default-audio=alsa --disable-shared && make -j4
	sudo make install
	rm ~/imp/mpg123-1.25.10.tar.bz2
fi

if [ "$confMPG123" == '6' ]; then
	# mpg123 v1.20.1 2014-06-17
	wget --no-check-certificate https://sourceforge.net/projects/mpg123/files/mpg123/1.20.1/mpg123-1.20.1.tar.bz2 -P ~/imp
	# wget --no-check-certificate https://sourceforge.net/projects/mpg123/files/mpg123/1.20.1/mpg123-1.20.1.tar.bz2.sig -P ~/imp
	tar -xvf mpg123-1.20.1.tar.bz2
	cd ~/imp/mpg123-1.20.1
	sudo ./configure --prefix=/usr --with-module-suffix=.so --disable-shared && make -j4
	sudo make install
	rm ~/imp/mpg123-1.20.1.tar.bz2
fi

if [ "$confMPG123" == '7' ]; then
	# Check for the mpg123 Offline Installation File
	if [ ! -f main-imp/offline/mpg123-1.20.1.tar.bz2]; then
	dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [mpg123-1.20.1.tar.bz2] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $mpg123FILEREF"  25 75
	mainMENU
	fi
	
	# mpg123 v1.20.1 2014-06-17
	cp ~/imp/main-imp/offline/mpg123-1.20.1.tar.bz2 ~/imp
	tar -xvf mpg123-1.20.1.tar.bz2
	cd ~/imp/mpg123-1.20.1
	sudo ./configure --prefix=/usr --with-module-suffix=.so --disable-shared && make -j4
	sudo make install
	rm ~/imp/mpg123-1.20.1.tar.bz2
fi

# Issue: mpg123: symbol lookup error: mpg123: undefined symbol: mpg123_getpar2
# Issue: main: [src/mpg123.c:309] error: out123 error 3: failure loading driver module
sudo export LD_LIBRARY_PATH=/usr/lib:/usr/lib/mpg123
export LD_LIBRARY_PATH=/usr/lib:/usr/lib/mpg123

cd ~/imp

# Finished Install 
dialog --no-collapse --title " * [mpg123] Install COMPLETE *" --ok-label CONTINUE --msgbox "$impLOGO $mpg123FILEREF"  25 75

mainMENU
}

mpg123UNINSTALL()
{
tput reset

# Stop mpg123 - Stop [IMP] if found
if [ -f /opt/retropie/configs/imp/stop.sh ]; then bash /opt/retropie/configs/imp/stop.sh; fi
pkill -STOP mpg123  > /dev/null 2>&1
pkill -KILL mpg123 > /dev/null 2>&1

# [apt-get remove] any Current Version if Found
sudo apt-get remove mpg123 -y

# [make uninstall] 0ther Versions of mpg123 Installed by [IMP] if Found 
if [ -f ~/imp/mpg123-1.29.3.tar.bz2 ]; then rm ~/imp/mpg123-1.29.3.tar.bz2; fi
if [ -d ~/imp/mpg123-1.29.3 ]; then
	cd ~/imp/mpg123-1.29.3
	sudo make uninstall
	cd ~/imp
	sudo rm ~/imp/mpg123-1.29.3 -R
fi
if [ -f ~/imp/mpg123-1.25.10.tar.bz2 ]; then rm ~/imp/mpg123-1.25.10.tar.bz2; fi
if [ -d ~/imp/mpg123-1.25.10 ]; then
	cd ~/imp/mpg123-1.25.10
	sudo make uninstall
	cd ~/imp
	sudo rm ~/imp/mpg123-1.25.10 -R
fi
if [ -f ~/imp/mpg123-1.20.1.tar.bz2 ]; then rm ~/imp/mpg123-1.20.1.tar.bz2; fi
if [ -d ~/imp/mpg123-1.20.1 ]; then
	cd ~/imp/mpg123-1.20.1
	sudo make uninstall
	cd ~/imp
	sudo rm ~/imp/mpg123-1.20.1 -R
fi
# Finished Install
dialog --no-collapse --title " * [mpg123] Uninstall COMPLETE *" --ok-label CONTINUE --msgbox "$impLOGO $mpg123FILEREF"  25 75
mainMENU
}

ESutilityMENU()
{
# Confirm Utility
pickUTILITY=$(dialog --stdout --no-collapse --title "     $IMPesUTILS     " \
	--ok-label OK --cancel-label Back \
	--menu "                #  [RP/ES] Utilities File Reference  # $IMPesFIXref" 25 75 20 \
	1 " [ParseGamelistOnly] OFF" \
	2 " [es_systems.cfg] Repair" \
	3 " [gamelist.xml] Refresh" \
	4 " [smb.conf] Update" \
	5 " [KILL] ES/Pegasus/AM" \
	6 " [REBOOT]")
	
# Utility Confirmed - Otherwise Back to Main Menu
if [ ! "$pickUTILITY" == '' ]; then
	if [ "$pickUTILITY" == '1' ]; then
		utilitySELECT='[ParseGamelistOnly] OFF'
		utilityDESC=" [ParseGamelistOnly] OFF if Experiencing [Assertion mType == FOLDER failed]"
	fi
	if [ "$pickUTILITY" == '2' ]; then
		utilitySELECT='[es_systems.cfg] Repair'
		utilityDESC=" Fix Mising .MP3 Extensions if Experiencing [Assertion mType == * failed]"
		utilityRUN=esSYSrepair
	fi
	if [ "$pickUTILITY" == '3' ]; then
		utilitySELECT='[gamelist.xml] Refresh'
		utilityDESC=" Restore RPMenu [gamelist.xml] File (Clean Entries P0ST [IMP] Install)"
		utilityRUN=gamelistREFRESH
	fi
	if [ "$pickUTILITY" == '4' ]; then
		utilitySELECT='[smb.conf] Update'
		utilityDESC=" Add Windows (Samba) Share for [~/RetroPie/retropiemenu/imp/music]"
		utilityRUN=smbUPDATE
	fi
	if [ "$pickUTILITY" == '5' ]; then
		utilitySELECT='[KILL] ES/Pegasus/AM'
		utilityDESC="       [KILL] ES/Pegasus/AM "
	fi
	if [ "$pickUTILITY" == '6' ]; then
		utilitySELECT='REBOOT'
		utilityDESC="       REBOOT "
	fi
	confUTILITY=$(dialog --stdout --no-collapse --title "$utilityDESC" \
		--ok-label OK --cancel-label Back \
		--menu "  ? ARE YOU SURE ?  " 25 75 20 \
		1 "><  $utilitySELECT  ><" \
		2 "Back to Menu")
	
	# Reboot Confirmed
	if [ "$confUTILITY" == '1' ] && [ "$utilitySELECT" == 'REBOOT' ]; then tput reset && sudo reboot; fi
	
	# # v2022.03 Addition - Scenario where Incorrect <game> Tag is used for a Sub-directory - Correct Tag should be <folder>
	# Set ParseGamelistOnly to OFF
	if [ "$confUTILITY" == '1' ] && [ "$utilitySELECT" == '[ParseGamelistOnly] OFF' ]; then
		sed -i 's/\"ParseGamelistOnly\"\ value=\"true\"/\"ParseGamelistOnly\"\ value=\"false\"/g' /opt/retropie/configs/all/emulationstation/es_settings.cfg
		finishUTILITY
	fi
	
	# Kill ES/Pegasus/AM Confirmed
	if [ "$utilitySELECT" == '[KILL] ES/Pegasus/AM' ]; then
		kill $(ps -eaf | grep "emulationstation" | awk '{print $2}')  > /dev/null 2>&1
		kill $(ps -eaf | grep "pegasus-fe" | awk '{print $2}')  > /dev/null 2>&1
		kill $(ps -eaf | grep "attract" | awk '{print $2}')  > /dev/null 2>&1
		finishUTILITY
	fi
	
	# Check if IMP Installed before Running Remaining Utilities
	if [ ! -d "$IMP" ]; then
		dialog --no-collapse --title "   * [IMP] INSTALL NOT DETECTED *   " --ok-label Back --msgbox "$impLOGO $IMPesFIXref"  25 75
		mainMENU
	fi

	# Utility Confirmed - Otherwise Back to Main Menu
	if [ "$confUTILITY" == '1' ]; then $utilityRUN; fi
	if [ "$confUTILITY" == '2' ]; then ESutilityMENU; fi
	ESutilityMENU
fi

mainMENU
}

esSYSrepair()
{
tput reset

# # v2022.02 Addition - Scenario where RetroPie is Updated and Removes [.mp3] support from <extension>
# Check and Modify x2 Locations to keep parity: [/etc/emulationstation/es_systems.cfg] + [~/.emulationstation/es_systems.cfg]

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

finishUTILITY
}

gamelistREFRESH()
{
tput reset

# Check for the Most Important Setup Directories and Files [gamelist*]
if [ ! -f main-imp/gamelist.imp ]; then
	dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [main-imp/gamelist.imp] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $IMPesFIXref"  25 75
	mainMENU
fi

if [ "$installFLAG" == 'offline' ]; then
	# Check for the Most Important Setup Directories and Files [gamelist*]
	if [ ! -f main-imp/gamelist.offline ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [main-imp/gamelist.offline] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $IMPesFIXref"  25 75
		mainMENU
	fi
fi

if [ "$installFLAG" == 'somafm' ]; then
	# Check for the Most Important Setup Directories and Files [gamelist*]
	if [ ! -f main-imp/icons/somafm/gamelist.somafm ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [main-imp/icons/somafm/gamelist.somafm] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $IMPesFIXref"  25 75
		mainMENU
	fi
fi

# Check for the Most Important Setup Directories and Files [gamelist*]
if [ ! -f main-imp/gamelist.imp ]; then
	dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [main-imp/gamelist.imp] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $IMPesFIXref"  25 75
	mainMENU
fi

if [ "$installFLAG" == 'offline' ]; then
	# Check for the Most Important Setup Directories and Files [gamelist*]
	if [ ! -f main-imp/gamelist.offline ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [main-imp/gamelist.offline] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $IMPesFIXref"  25 75
		mainMENU
	fi
fi

if [ "$installFLAG" == 'somafm' ]; then
	# Check for the Most Important Setup Directories and Files [gamelist*]
	if [ ! -f main-imp/icons/somafm/gamelist.somafm ]; then
		dialog --no-collapse --title " * [IMP] SETUP FILES MISSING * [main-imp/icons/somafm/gamelist.somafm] * PLEASE VERIFY *" --ok-label CONTINUE --msgbox "$impLOGO $IMPesFIXref"  25 75
		mainMENU
	fi
fi

# Restore gamelist.xml OPT if Backup is found
if [ -f /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml.b4imp ]; then
    mv /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml.b4imp /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
fi

# Restore gamelist.xml retropiemenu if Backup is found
if [ -f ~/RetroPie/retropiemenu/gamelist.xml.b4imp ]; then
    mv ~/RetroPie/retropiemenu/gamelist.xml.b4imp ~/RetroPie/retropiemenu/gamelist.xml
fi

# [gamelist.xml] Modifications for retropiemenu OPT
if [ -f /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml ]; then
	# Parse all lines Except </gameList>
	cat /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml | grep -v "</gameList>" > main-imp/gamelist.xml
	
	# [gamelist.xml] might NOT be properly formatted - Make it so
	if [ ! -f main-imp/gamelist.xml ]; then echo '<?xml version="1.0"?>' > main-imp/gamelist.xml; fi
	if [ $(cat main-imp/gamelist.xml | grep -q '<gameList>' ; echo $?) == '1' ]; then echo $'\n<gameList>' >> main-imp/gamelist.xml; fi
	
	# Rebuild retropiemenu gamelist.xml with [IMP]
	cat main-imp/gamelist.imp >> main-imp/gamelist.xml
	
	# Add Internet Radio Station Entries to gamelist.xml
	if [ ! "$installFLAG" == 'offline' ]; then cat main-imp/gamelist.streams >> main-imp/gamelist.xml; fi
	
	# Add SomaFM Entries to gamelist.xml
	if [ "$installFLAG" == 'somafm' ]; then cat main-imp/icons/somafm/gamelist.somafm >> main-imp/gamelist.xml; fi
	
	# Add the Finishing Line to gamelist.xml
	# echo $'\n</gameList>' >> main-imp/gamelist.xml
	echo '</gameList>' >> main-imp/gamelist.xml
	
	# Backup gamelist if not exist already
	if [ ! -f /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml.b4imp ]; then mv /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml.b4imp 2>/dev/null; fi
	
	# Replace retropiemenu gamelist.xml with [IMP]
	mv main-imp/gamelist.xml /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
	
	# Clean up tmp files
	rm main-imp/gamelist.xml > /dev/null 2>&1
fi

# [gamelist.xml] Modifications for retropiemenu rpMenu
if [ -f ~/RetroPie/retropiemenu/gamelist.xml ]; then	
	# Parse all lines Except </gameList>
	cat ~/RetroPie/retropiemenu/gamelist.xml | grep -v "</gameList>" > main-imp/gamelist.xml
	
	# [gamelist.xml] might NOT be properly formatted - Make it so
	if [ ! -f main-imp/gamelist.xml ]; then echo '<?xml version="1.0"?>' > main-imp/gamelist.xml; fi
	if [ $(cat main-imp/gamelist.xml | grep -q '<gameList>' ; echo $?) == '1' ]; then echo $'\n<gameList>' >> main-imp/gamelist.xml; fi
	
	# Rebuild retropiemenu gamelist.xml with [IMP]
	cat main-imp/gamelist.imp >> main-imp/gamelist.xml
	
	# Add Internet Radio Station Entries to gamelist.xml
	if [ ! "$installFLAG" == 'offline' ]; then cat main-imp/gamelist.streams >> main-imp/gamelist.xml; fi
	
	# Add SomaFM Entries to gamelist.xml
	if [ "$installFLAG" == 'somafm' ]; then cat main-imp/icons/somafm/gamelist.somafm >> main-imp/gamelist.xml; fi
	
	# Add the Finishing Line to gamelist.xml
	# echo $'\n</gameList>' >> main-imp/gamelist.xml
	echo '</gameList>' >> main-imp/gamelist.xml
	
	# Backup gamelist.xml if not exist already
	if [ ! -f ~/RetroPie/retropiemenu/gamelist.xml.b4imp ]; then mv ~/RetroPie/retropiemenu/gamelist.xml ~/RetroPie/retropiemenu/gamelist.xml.b4imp 2>/dev/null; fi
	
	# Replace retropiemenu gamelist.xml with [IMP]
	mv main-imp/gamelist.xml ~/RetroPie/retropiemenu/gamelist.xml
	
	# Clean up tmp files
	rm main-imp/gamelist.xml > /dev/null 2>&1
fi

finishUTILITY
}

smbUPDATE()
{
tput reset

# Restore [smb.conf] if Backup is found
if [ -f /etc/samba/smb.conf.b4imp ]; then sudo mv /etc/samba/smb.conf.b4imp /etc/samba/smb.conf; fi

# Symbolic Link to [../roms/music] NOT Shared in Samba
if [ -f /etc/samba/smb.conf ]; then
	# Backup [/etc/samba/smb.conf] if not exist already
	if [ ! -f /etc/samba/smb.conf.b4imp ]; then sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.b4imp 2>/dev/null; fi
	
	if [ ! "$(cat /etc/samba/smb.conf | grep -q "path = \"\/home\/$USER\/RetroPie\/retropiemenu\/imp\/music\"" ; echo $?)" == '0' ]; then
		# ADD Samba Share to [~/RetroPie/retropiemenu/imp/music]
		cat /etc/samba/smb.conf > /dev/shm/smb.conf
		echo '[music]' >> /dev/shm/smb.conf
		echo 'comment = music' >> /dev/shm/smb.conf
		echo "path = \"/home/$USER/RetroPie/retropiemenu/imp/music\"" >> /dev/shm/smb.conf
		echo 'writeable = yes' >> /dev/shm/smb.conf
		echo 'guest ok = yes' >> /dev/shm/smb.conf
		echo 'create mask = 0644' >> /dev/shm/smb.conf
		echo 'directory mask = 0755' >> /dev/shm/smb.conf
		echo "force user = $USER" >> /dev/shm/smb.conf
		sudo mv /dev/shm/smb.conf /etc/samba/smb.conf
		
		# Restart [SMB]
		# sudo systemctl restart smbd.service
	fi
fi

finishUTILITY
}

finishUTILITY()
{
# Finished Refresh - Confirm Reboot
UTILITYconfREBOOT=$(dialog --stdout --no-collapse --title " $utilitySELECT *COMPLETE*" \
	--ok-label OK --cancel-label Back \
	--menu "$IMPesFIXref" 25 75 20 \
	1 "Back to Menu" \
	2 "REBOOT")
# Reboot Confirm - Otherwise Exit
if [ "$UTILITYconfREBOOT" == '2' ]; then tput reset && sudo reboot; fi

tput reset
ESutilityMENU
}

# DISCLAIMER
tput reset
dialog --no-collapse --title "   *DISCLAIMER* Install at your own Risk   " --ok-label CONTINUE --msgbox "$impLOGO $impFILEREF"  25 75

mainMENU

tput reset
exit 0

