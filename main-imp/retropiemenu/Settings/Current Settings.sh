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
musicROMS=~/RetroPie/roms/music

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

if [ $aside_music == "1" ]; then aside_music=${GREEN}"ON "; else aside_music=${RED}"OFF"; fi
if [ $bside_music == "1" ]; then bside_music=${GREEN}"ON "; else bside_music=${RED}"OFF"; fi
if [ $music_start == "1" ]; then music_start=${GREEN}"ON "; else music_start=${RED}"OFF"; fi
if [ $music_over_game == "1" ]; then music_over_game=${GREEN}"ON "; else music_over_game=${RED}"OFF"; fi
if ! [ $delay_startup == "000" ]; then delay_startup=${YEL}"$delay_startup"; else delay_startup=${RED}"OFF"; fi
if ! [ $delay_playback == "00" ]; then delay_playback=${YEL}"$delay_playback "; else delay_playback=${RED}"OFF"; fi
if [ $fade_out == "1" ]; then fade_out=${GREEN}"ON "; else fade_out=${RED}"OFF"; fi
if [ $http_setting == "1" ]; then http_setting=${GREEN}"ON "; else http_setting=${RED}"OFF"; fi
if [ $infinite_mode == "1" ]; then infinite_mode=${GREEN}"ON "; else infinite_mode=${RED}"OFF"; fi
if [ $lite_mode == "1" ]; then lite_mode=${GREEN}"ON "; else lite_mode=${RED}"OFF"; fi

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
echo "                        '---. .-:'                "
echo -e "         ${RED}I${YEL}ntegrated      '::-'..-'        for     "
echo -e "         ${RED}M${YEL}usic             .-- .--       ${RED}R${YEL}etro${RED}P${YEL}ie  "
echo -e "         ${RED}P${YEL}layer          .:-:.'''        ${RED}v${YEL}$versionIMP  "
echo -e "${NC} ,-------------------------------------------------------.               "
echo -e " |    INFINITE Mode:   $infinite_mode${NC}  |     Music @Startup:   $music_start${NC}  | "
echo -e " |        LITE Mode:   $lite_mode${NC}  |     DELAY @Startup:   $delay_startup${NC}  | "
echo -e " |       BGM A-SIDE:   $aside_music${NC}  |    Music OVER Game:   $music_over_game${NC}  | "
echo -e " |       BGM B-SIDE:   $bside_music${NC}  |  Volume FADE @Game:   $fade_out${NC}  | "
echo -e " |      HTTP Server:   $http_setting${NC}  |    DELAY @Game End:   $delay_playback${NC}  | "
echo " \`-------------------------------------------------------'  "
echo -e "     Address: ${blue}[${YEL}http://$currentHTTP${blue}]${NC} [$http_server${NC}]"
echo -e "       Music Folder: ${YEL}$musicROMS${NC}"
read -p " < OK >" </dev/tty
tput reset
exit 0
