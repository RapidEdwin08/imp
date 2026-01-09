#!/bin/bash

# Create ES Scripts Folder
mkdir /opt/retropie/configs/all/emulationstation/scripts > /dev/null 2>&1

# Enable Idle IMP @ScreenSaver
mkdir /opt/retropie/configs/all/emulationstation/scripts/screensaver-start > /dev/null 2>&1
echo '#!/bin/bash
bash /opt/retropie/configs/imp/run-onstart.sh idle &
exit 0' > /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh
chmod 755 /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh

mkdir /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop > /dev/null 2>&1
echo '#!/bin/bash
bash /opt/retropie/configs/imp/run-onend.sh idle &
exit 0' > /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop/impstart.sh
chmod 755 /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop/impstart.sh

#tput reset
exit 0
