#!/bin/bash
tput reset
blue='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YEL='\033[1;33m'
NC='\033[0m'        #No Color

IMP=/opt/retropie/configs/imp
versionIMP=$(cat $IMP/VERSION)
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
musicDIR=~/RetroPie/retropiemenu/imp/music

aside_music=$(cat $IMPSettings/a-side.flag)
bside_music=$(cat $IMPSettings/b-side.flag)
music_start=$(cat $IMPSettings/music-startup.flag)
music_over_game=$(cat $IMPSettings/music-over-games.flag)
delay_playback=$(cat $IMPSettings/delay-playback.flag)
delay_startup=$(cat $IMPSettings/delay-startup.flag)
fade_out=$(cat $IMPSettings/fade-out.flag)
http_setting=$(cat $IMPSettings/http-server.flag)
http_port=$(cat $IMPSettings/http-server.port)
infinite_mode=$(cat $IMPSettings/infinite.flag)
lite_mode=$(cat $IMPSettings/lite.flag)
randomizer_boot=$(cat $IMPSettings/randomizerboot.flag)
randomizer_mode=$(cat $IMPSettings/randomizer.flag)
startupsong_mode=$(cat $IMPSettings/startupsong.flag)
shuffleboot_mode=$(cat $IMPSettings/shuffleboot.flag)

if [ $aside_music == "1" ]; then aside_music=${GREEN}" ON"; else aside_music=${RED}"OFF"; fi
if [ $bside_music == "1" ]; then bside_music=${GREEN}"ON "; else bside_music=${RED}"OFF"; fi
if [ $music_start == "1" ]; then music_start=${GREEN}" ON"; else music_start=${RED}"OFF"; fi
#if [ $music_over_game == "1" ]; then music_over_game=${GREEN}"ON "; else music_over_game=${RED}"OFF"; fi
if ! [ $delay_startup == "000" ]; then delay_startup=${YEL}"$delay_startup"; else delay_startup=${RED}"OFF"; fi
if ! [ $delay_playback == "00" ]; then delay_playback=${YEL}"$delay_playback "; else delay_playback=${RED}"OFF"; fi
if [ $fade_out == "1" ]; then fade_out=${GREEN}"ON "; else fade_out=${RED}"OFF"; fi
if [ $http_setting == "1" ]; then http_setting=${GREEN}"ON "; else http_setting=${RED}"OFF"; fi
if [ $infinite_mode == "1" ]; then infinite_mode=${GREEN}"ON "; else infinite_mode=${RED}"OFF"; fi
if [ $lite_mode == "1" ]; then lite_mode=${GREEN}"ON "; else lite_mode=${RED}"OFF"; fi
if [ $startupsong_mode == "1" ]; then startupsong_mode=${GREEN}"ON "; else startupsong_mode=${RED}"OFF"; fi
if [ $shuffleboot_mode == "1" ]; then shuffleboot_mode=${GREEN}"ON "; else shuffleboot_mode=${RED}"OFF"; fi
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "0" ]; then randomizer_mode=${RED}"ALL"; fi
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "1" ]; then randomizer_mode=${RED}"ALL"; fi
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "2" ]; then randomizer_mode=${RED}"BGM"; fi
if [ $randomizer_boot == "0" ] &&  [ $randomizer_mode == "3" ]; then randomizer_mode=${RED}"PLS"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "0" ]; then randomizer_mode=${GREEN}"ALL"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "1" ]; then randomizer_mode=${GREEN}"ALL"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "2" ]; then randomizer_mode=${GREEN}"BGM"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "3" ]; then randomizer_mode=${GREEN}"PLS"; fi

if [ -f /opt/retropie/configs/all/emulationstation/scripts/quit/quitsong.sh ]; then
	quitsong_mode=${GREEN}"ON "
else
	quitsong_mode=${RED}"OFF"
fi

# Idle Settings for SLEEP
idleORkill="   Stop IMP"
if [ -f /opt/retropie/configs/all/emulationstation/scripts/sleep/impstop.sh ] && [ -f /opt/retropie/configs/all/emulationstation/scripts/wake/impstart.sh ]; then
	sleepIMPsleep=${GREEN}"ON "
	if [ -f /opt/retropie/configs/all/emulationstation/scripts/sleep/impXdisplay0.sh ] && [ -f /opt/retropie/configs/all/emulationstation/scripts/wake/impXdisplay1.sh ]; then
		idleORkill=${RED}"KillDisplay"
	fi
else
	sleepIMPsleep=${RED}"OFF"
fi

# Idle Settings for SCREENSAVER
if [ -f /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh ] && [ -f /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop/impstart.sh ]; then
	sleepIMPscreen=${GREEN}"ANY"
	if [ "$(cat /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh | grep -q 'random video' ; echo $?)" == '0' ]; then
		sleepIMPscreen=${GREEN}"VID"
	fi
else
	sleepIMPscreen=${RED}"OFF"
fi

# Lower Idle Settings for SCREENSAVER
lowerVOLUME=$(cat $IMPSettings/lower-idle.volume)
if [ $lowerVOLUME == "32768" ]; then volume_percent="MAX"; fi
if [ $lowerVOLUME == "29484" ]; then volume_percent="%90"; fi
if [ $lowerVOLUME == "26208" ]; then volume_percent="%80"; fi
if [ $lowerVOLUME == "22932" ]; then volume_percent="%70"; fi
if [ $lowerVOLUME == "19656" ]; then volume_percent="%60"; fi
if [ $lowerVOLUME == "16380" ]; then volume_percent="%50"; fi
if [ $lowerVOLUME == "13104" ]; then volume_percent="%40"; fi
if [ $lowerVOLUME == "9828" ]; then volume_percent="%30"; fi
if [ $lowerVOLUME == "6552" ]; then volume_percent="%20"; fi
if [ $lowerVOLUME == "3276" ]; then volume_percent="%10"; fi
if [ $lowerVOLUME == "1638" ]; then volume_percent="%5 "; fi
#sleepIMPvolume=${RED}"$volume_percent"
sleepIMPvolume="   "

stopORIdle=" Stop IMP"
lower_idle=$(cat $IMPSettings/lower-idle.flag)
if [ $lower_idle == "1" ]; then
	sleepIMPvolume=${YEL}"$volume_percent"
	stopORIdle=Volume${YEL}"$sleepIMPvolume"
fi

if [ $music_over_game == "1" ]; then
	music_over_game=${GREEN}"ON "
elif [ $music_over_game == "2" ]; then
	music_over_game=${YEL}"$volume_percent"
else
	music_over_game=${RED}"OFF"
fi

omxM0Nflag=$(cat $IMPSettings/0mxmon.flag)
#omxmonSETTING="           "
omxmonSETTING=0MXM0N:${RED}"OFF "
omxwaitSETTING="$(cat $IMPSettings/0mxmon.sleep)"
if [ $omxM0Nflag == "1" ]; then
	omxmonSETTING="${YEL}"0MX${blue}"M0N"":${GREEN}"$omxwaitSETTING""
fi

currentIP=$(hostname -I)
echo $currentIP:$http_port > $IMPSettings/current.ip
currentHTTP=$(cat $IMPSettings/current.ip | tr -d "[:space:]")

httpPORT=$(cat $IMPSettings/http-server.port)
# DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Python2.x is no longer maintained.
# httpPID=$(ps -ef |grep SimpleHTTPServer |grep $http_port |awk '{print $2}')
httpPID=$(ps -ef |grep http.server |grep $http_port |awk '{print $2}')
if [[ "$httpPID" == '' ]]; then http_server=${RED}"STOPPED"; else http_server=${GREEN}"RUNNING"; fi

tput reset
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo -e "${YEL}"
echo "                          _-+-_                    "
echo -e "                         '#${RED}*${YEL}=${RED}*${YEL}#-                  "
echo -e "                    ^....-|:${RED}^${YEL}:|:-../:^            "
echo -e "                    '-+++#::${RED}_${YEL}::#+++-''            "
echo "                   ':--.-:-----::---:-            "
echo "                  '::.   -.------   .-:           "
echo "                   :-   ':------:. '::.           "
echo "                   =-'  .::-..-::-  ='            "
echo "                        .::-.'-:--                "
echo -e "         ${RED}I${YEL}ntegrated     '---. .-:'        for        "
echo -e "         ${RED}M${YEL}usic          '::-'..-'        ${RED}R${YEL}etro${RED}P${YEL}ie     "
echo -e "         ${RED}P${YEL}layer          .:-:.'''        ${RED}v${YEL}$versionIMP  "
echo -e "${NC} ,-------------------------------------------------------.               "
echo -e " | Music @Boot:$music_start${NC}  Delay: $delay_startup${NC} |          LITE Mode: $lite_mode${NC} | "
echo -e " | startup.mp3: $startupsong_mode${NC} @quit: $quitsong_mode${NC} |      INFINITE Mode: $infinite_mode${NC} | "
echo -e " | BGM A~SIDE: $aside_music${NC} B~SIDE: $bside_music${NC} |    Music OVER Game: $music_over_game${NC} | "
echo -e " | Shuffle Playlist @Boot: $shuffleboot_mode${NC} | FADE Volume Out/In: $fade_out${NC} | "
echo -e " | $omxmonSETTING${NC} RANDOMIZER: $randomizer_mode${NC} |    DELAY @Game End: $delay_playback${NC} | "
echo -e " | $stopORIdle${NC} @Screensaver: $sleepIMPscreen${NC} | $idleORkill${NC} @Sleep: $sleepIMPsleep${NC} | "
echo " \`-------------------------------------------------------'  "
echo -e " http.server: [$http_setting${NC}] ${blue}[${YEL}http://$currentHTTP${blue}]${NC} [$http_server${NC}]"
echo -e " Music: ${YEL}$musicDIR${NC}"
read -p " ..." </dev/tty
tput reset
exit 0
