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

# IMP Kill Display @ESSleep
cat /opt/retropie/configs/imp/impXdisplay0.sh > /opt/retropie/configs/all/emulationstation/scripts/sleep/impXdisplay0.sh
chmod 755 /opt/retropie/configs/all/emulationstation/scripts/sleep/impXdisplay0.sh

cat /opt/retropie/configs/imp/impXdisplay1.sh > /opt/retropie/configs/all/emulationstation/scripts/wake/impXdisplay1.sh
chmod 755 /opt/retropie/configs/all/emulationstation/scripts/wake/impXdisplay1.sh

#tput reset
exit 0
