#!/bin/bash

# Create ES Scripts Folder
mkdir /opt/retropie/configs/all/emulationstation/scripts > /dev/null 2>&1

# Enable Idle IMP @ESSleep
mkdir /opt/retropie/configs/all/emulationstation/scripts/sleep > /dev/null 2>&1
echo '#!/bin/bash
bash /opt/retropie/configs/imp/run-onstart.sh sleep &
exit 0' > /opt/retropie/configs/all/emulationstation/scripts/sleep/impstop.sh
chmod 755 /opt/retropie/configs/all/emulationstation/scripts/sleep/impstop.sh

mkdir /opt/retropie/configs/all/emulationstation/scripts/wake > /dev/null 2>&1
echo '#!/bin/bash
bash /opt/retropie/configs/imp/run-onend.sh sleep &
exit 0' > /opt/retropie/configs/all/emulationstation/scripts/wake/impstart.sh
chmod 755 /opt/retropie/configs/all/emulationstation/scripts/wake/impstart.sh

# Remove IMP Kill Display @ESSleep
rm /opt/retropie/configs/all/emulationstation/scripts/sleep/impXdisplay0.sh > /dev/null 2>&1
rm /opt/retropie/configs/all/emulationstation/scripts/wake/impXdisplay1.sh > /dev/null 2>&1

#tput reset
exit 0
