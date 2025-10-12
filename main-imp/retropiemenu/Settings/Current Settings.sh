#!/bin/bash
# 202510 Converted to dialog

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
quitsong_flag=$(cat $IMPSettings/quitsong.flag)

if [ $aside_music == "1" ]; then aside_music=" \Z2ON\Zn"; else aside_music="\Z1OFF\Zn"; fi
if [ $bside_music == "1" ]; then bside_music=" \Z2ON\Zn"; else bside_music="\Z1OFF\Zn"; fi
if [ $music_start == "1" ]; then music_start=" \Z2ON\Zn"; else music_start="\Z1OFF\Zn"; fi
#if [ $music_over_game == "1" ]; then music_over_game=" \Z2ON\Zn"; else music_over_game="\Z1OFF\Zn"; fi
if ! [ $delay_startup == "000" ]; then delay_startup="\Z4$delay_startup\Zn"; else delay_startup="\Z1OFF\Zn"; fi
if ! [ $delay_playback == "00" ]; then delay_playback="\Z4$delay_playback\Zn "; else delay_playback="\Z1OFF\Zn"; fi
if [ $fade_out == "1" ]; then fade_out="\Z2x1\Zn "; elif [ $fade_out == "5" ]; then fade_out="\Z2x5\Zn "; elif [ $fade_out == "10" ]; then fade_out="\Z2x10\Zn"; else fade_out="\Z1OFF\Zn"; fi
if [ $http_setting == "1" ]; then http_setting=" \Z2ON\Zn"; else http_setting="\Z1OFF\Zn"; fi
if [ $infinite_mode == "0" ]; then infinite_mode="\Z1[ ]\Zn"; infinite_state="\Z1OFF\Zn"; fi
if [ $infinite_mode == "1" ]; then infinite_mode="\Z2[1]\Zn"; infinite_state="\Z2ON\Zn "; fi
if [ $infinite_mode == "2" ]; then infinite_mode="\Z2ALL\Zn"; infinite_state="\Z2ON\Zn "; fi
if [ $lite_mode == "1" ]; then lite_mode="\Z2ON\Zn "; else lite_mode="\Z1OFF\Zn"; fi
if [ $startupsong_mode == "1" ]; then startupsong_mode="\Z2ON\Zn "; else startupsong_mode="\Z1OFF\Zn"; fi
if [ $shuffleboot_mode == "1" ]; then shuffleboot_mode="\Z2ON\Zn "; else shuffleboot_mode="\Z1OFF\Zn"; fi
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "0" ]; then randomizer_mode="\Z1ALL\Zn"; randomizer_boot="\Z1OFF\Zn"; fi
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "0" ]; then randomizer_mode="\Z1ALL\Zn"; randomizer_boot="\Z1OFF\Zn"; fi
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "1" ]; then randomizer_mode="\Z1ALL\Zn"; randomizer_boot="\Z1OFF\Zn"; fi
if [ $randomizer_boot == "0" ] && [ $randomizer_mode == "2" ]; then randomizer_mode="\Z1BGM\Zn"; randomizer_boot="\Z1OFF\Zn"; fi
if [ $randomizer_boot == "0" ] &&  [ $randomizer_mode == "3" ]; then randomizer_mode="\Z1PLS\Zn"; randomizer_boot="\Z1OFF\Zn"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "0" ]; then randomizer_mode="\Z2ALL\Zn"; randomizer_boot=" \Z2ON\Zn"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "1" ]; then randomizer_mode="\Z2ALL\Zn"; randomizer_boot=" \Z2ON\Zn"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "2" ]; then randomizer_mode="\Z2BGM\Zn"; randomizer_boot=" \Z2ON\Zn"; fi
if [ $randomizer_boot == "1" ] && [ $randomizer_mode == "3" ]; then randomizer_mode="\Z2PLS\Zn"; randomizer_boot=" \Z2ON\Zn"; fi
if [ $quitsong_flag == "1" ]; then quitsong_mode="\Z2ON\Zn "; else quitsong_mode="\Z1OFF\Zn"; fi

# Idle Settings for SLEEP
idleORkill="   Stop IMP"
if [ -f /opt/retropie/configs/all/emulationstation/scripts/sleep/impstop.sh ] && [ -f /opt/retropie/configs/all/emulationstation/scripts/wake/impstart.sh ]; then
	sleepIMPsleep="\Z2ON\Zn "
	if [ -f /opt/retropie/configs/all/emulationstation/scripts/sleep/impXdisplay0.sh ] && [ -f /opt/retropie/configs/all/emulationstation/scripts/wake/impXdisplay1.sh ]; then
		idleORkill="\Z1KillDisplay\Zn"
	fi
else
	sleepIMPsleep="\Z1OFF\Zn"
fi

# Idle Settings for SCREENSAVER
if [ -f /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh ] && [ -f /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop/impstart.sh ]; then
	sleepIMPscreen="\Z2ANY\Zn"
	if [ "$(cat /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh | grep -q 'random video' ; echo $?)" == '0' ]; then
		sleepIMPscreen="\Z2VID\Zn"
	fi
else
	sleepIMPscreen="\Z1OFF\Zn"
fi

# Lower Idle Settings for SCREENSAVER
lowerVOLUME=$(cat $IMPSettings/lower-idle.volume)
if [ $lowerVOLUME == "32768" ]; then volume_percent="\Z4MAX\Zn"; fi
if [ $lowerVOLUME == "29484" ]; then volume_percent="\Z4%90\Zn"; fi
if [ $lowerVOLUME == "26208" ]; then volume_percent="\Z4%80\Zn"; fi
if [ $lowerVOLUME == "22932" ]; then volume_percent="\Z4%70\Zn"; fi
if [ $lowerVOLUME == "19656" ]; then volume_percent="\Z4%60\Zn"; fi
if [ $lowerVOLUME == "16380" ]; then volume_percent="\Z4%50\Zn"; fi
if [ $lowerVOLUME == "13104" ]; then volume_percent="\Z4%40\Zn"; fi
if [ $lowerVOLUME == "9828" ]; then volume_percent="\Z4%30\Zn"; fi
if [ $lowerVOLUME == "6552" ]; then volume_percent="\Z4%20\Zn"; fi
if [ $lowerVOLUME == "3276" ]; then volume_percent="\Z4%10\Zn"; fi
if [ $lowerVOLUME == "1638" ]; then volume_percent="\Z6%5\Zn "; fi
#sleepIMPvolume="$volume_percent"
sleepIMPvolume="   "

stopORIdle=" Stop IMP"
lower_idle=$(cat $IMPSettings/lower-idle.flag)
if [ $lower_idle == "1" ]; then
	sleepIMPvolume="$volume_percent"
	stopORIdle=Volume"$sleepIMPvolume"
fi

if [ $music_over_game == "1" ]; then
	music_over_game="\Z2ON\Zn "
elif [ $music_over_game == "2" ]; then
	music_over_game="$volume_percent"
else
	music_over_game="\Z1OFF\Zn"
fi

##omxM0Nflag=$(cat $IMPSettings/0mxmon.flag)
#omxmonSETTING="           "
##omxmonSETTING=0MXM0N:"OFF "
##omxwaitSETTING="$(cat $IMPSettings/0mxmon.sleep)"
##if [ $omxM0Nflag == "1" ]; then
	##omxmonSETTING=""0MX"M0N"":"$omxwaitSETTING""
##fi

currentIP=$(hostname -I)
echo $currentIP:$http_port > $IMPSettings/current.ip
currentHTTP=$(cat $IMPSettings/current.ip | tr -d "[:space:]")

httpPORT=$(cat $IMPSettings/http-server.port)
# DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Python2.x is no longer maintained.
# httpPID=$(ps -ef |grep SimpleHTTPServer |grep $http_port |awk '{print $2}')
httpPID=$(ps -ef |grep http.server |grep $http_port |awk '{print $2}')
if [[ "$httpPID" == '' ]]; then http_server="\Z1STOPPED\Zn"; else http_server="\Z2RUNNING\Zn"; fi

impSETTINGScurrent=$(
echo "                            \Zb_-+-_                    
                           '#\Zn\Z1*\Zn\Zb=\Zn\Z1*\Zn\Zb#-                  
                      \Z7^\Zn\Zb....-|:\Z7^\Zn\Zb:|:-../:\Z7^\Zn\Zb            
                      '-+++#::\Z7_\Zn\Zb::#+++-''            
                     .:;':--.-:-----::---:-            
                    '::.   -.------   .-:           
                     :-   ':------:. '::.           
                     =-'  .::-..-::-  ='            
                          .::-.'-\Z7^\Zn\Zb--                
           \Zn\Z1I\Znntegrated     \Zb'-\Z7^\Zn\Zb-. .-:'\Zn      for        
           \Z1M\Znusic           \Zb'::-'..-'\Zn      \Z1R\Znetro\Z1P\Znie 
           \Z1P\Znlayer          \Zb.:-:.'''\Zn       \Z1v\Zn$versionIMP
   ------------------------------------------------------- 
  | Music @Boot:$music_start  Delay: $delay_startup |  REPEAT: $infinite_state  Mode: $infinite_mode |
  | startup.mp3: $startupsong_mode @quit: $quitsong_mode | FADE Volume Out/In: $fade_out |
  | BGM A~SIDE: $aside_music B~SIDE: $bside_music |    Music OVER Game: $music_over_game |
  | Shuffle Playlist @Boot: $shuffleboot_mode |    DELAY @Game End: $delay_playback |
  | Randomizer: $randomizer_boot   Mode: $randomizer_mode |          LITE Mode: $lite_mode |
  | $stopORIdle @Screensaver: $sleepIMPscreen | $idleORkill @Sleep: $sleepIMPsleep |
   ------------------------------------------------------- 
  http.server: [$http_setting] \Zb[http://$currentHTTP]\Zn [$http_server]
  Music: \Zb$musicDIR\Zn
"
)

tput reset
dialog --colors --no-collapse --title "   Current Settings" --ok-label OK --msgbox "$impSETTINGScurrent"  0 0
#read -p " ..." </dev/tty
tput reset
exit 0
