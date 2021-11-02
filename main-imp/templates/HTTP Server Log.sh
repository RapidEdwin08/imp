#!/bin/bash
# Supreme Build V2 RéGaLaD/WDG (PiZero 20180827) has a bug where [RetroPie-Setup] does Not have Joypad Support
# THIS AUTO-TIMEOUT SCRIPT DOES NOT REQUIRE INPUT TO CLOSE
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
HTTPLog=$(cat $IMPSettings/http-server.log)
http_setting=$(cat $IMPSettings/http-server.flag)
if [ $http_setting == "1" ]; then http_setting="ON "; else http_setting="OFF"; fi
httpPORT=$(cat $IMPSettings/http-server.port)

# DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Python2.7 is no longer maintained.
# httpPID=$(ps -ef |grep SimpleHTTPServer |grep $httpPORT |awk '{print $2}')
httpPID=$(ps -ef |grep http.server |grep $httpPORT |awk '{print $2}')
if [[ "$httpPID" == '' ]]; then http_server="STOPPED"; else http_server="RUNNING"; fi

currentIP=$(hostname -I)
echo $currentIP:$httpPORT > $IMPSettings/current.ip
currentHTTP=$(cat $IMPSettings/current.ip | tr -d "[:space:]")

currentLOG=$(
echo
echo "$HTTPLog"
echo
)

dialog --no-collapse --title "   HTTP Server: $http_setting    <  $currentHTTP  >    Status: $http_server   " --msgbox "$currentLOG"  0 0 &
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