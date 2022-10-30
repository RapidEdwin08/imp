#!/bin/bash
# Disable Idle IMP @ScreenSaver
rm /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh > /dev/null 2>&1
rm /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop/impstart.sh > /dev/null 2>&1
rm -d /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/ > /dev/null 2>&1
rm -d /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop/ > /dev/null 2>&1
rm -d /opt/retropie/configs/all/emulationstation/scripts/ > /dev/null 2>&1

#tput reset
exit 0
