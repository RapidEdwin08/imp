#!/bin/bash
# Disable Idle IMP @ESSleep
rm /opt/retropie/configs/all/emulationstation/scripts/sleep/impstop.sh > /dev/null 2>&1
rm /opt/retropie/configs/all/emulationstation/scripts/wake/impstart.sh > /dev/null 2>&1
rm /opt/retropie/configs/all/emulationstation/scripts/sleep/impXdisplay0.sh > /dev/null 2>&1
rm /opt/retropie/configs/all/emulationstation/scripts/wake/impXdisplay1.sh > /dev/null 2>&1
rm -d /opt/retropie/configs/all/emulationstation/scripts/sleep/ > /dev/null 2>&1
rm -d /opt/retropie/configs/all/emulationstation/scripts/wake/ > /dev/null 2>&1
rm -d /opt/retropie/configs/all/emulationstation/scripts/ > /dev/null 2>&1

#tput reset
exit 0
