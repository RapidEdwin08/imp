#!/bin/bash

# Disable quit.mp3 @ESQuit
rm /opt/retropie/configs/all/emulationstation/scripts/quit/quitsong.sh > /dev/null 2>&1
rm -d /opt/retropie/configs/all/emulationstation/scripts/quit/ > /dev/null 2>&1
rm -d /opt/retropie/configs/all/emulationstation/scripts/ > /dev/null 2>&1

#tput reset
exit 0
