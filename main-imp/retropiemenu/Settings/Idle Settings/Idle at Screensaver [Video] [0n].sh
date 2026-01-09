#!/bin/bash

# Create ES Scripts Folder
mkdir /opt/retropie/configs/all/emulationstation/scripts > /dev/null 2>&1

# Enable Idle IMP @ScreenSaver RandomVideo 0nly
mkdir /opt/retropie/configs/all/emulationstation/scripts/screensaver-start > /dev/null 2>&1
echo '#!/bin/bash' > /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh

# Check for screenSAVERsetting RandomVideo
echo "# Perform Actions 0NLY IF ScreenSaver is Set to [random video] or [randomvideo] - 0therwise EXIT
screenSAVERsetting=\$(cat /opt/retropie/configs/all/emulationstation/es_settings.cfg | grep \"ScreenSaverBehavior\" | awk -F'=' '{print \$3}'| cut -c 2- | rev | cut -c 5- | rev)
if [ ! \"\$screenSAVERsetting\" == \"random video\" ] && [ ! \"\$screenSAVERsetting\" == \"randomvideo\" ]; then exit 0; fi
" >> /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh

echo 'bash /opt/retropie/configs/imp/run-onstart.sh idle &
exit 0' >> /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh
chmod 755 /opt/retropie/configs/all/emulationstation/scripts/screensaver-start/impstop.sh

mkdir /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop > /dev/null 2>&1
echo '#!/bin/bash' > /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop/impstart.sh

#  Check for screenSAVERsetting RandomVideo
echo "# Perform Actions 0NLY IF ScreenSaver is Set to [random video] or [randomvideo] - 0therwise EXIT
screenSAVERsetting=\$(cat /opt/retropie/configs/all/emulationstation/es_settings.cfg | grep \"ScreenSaverBehavior\" | awk -F'=' '{print \$3}'| cut -c 2- | rev | cut -c 5- | rev)
if [ ! \"\$screenSAVERsetting\" == \"random video\" ] && [ ! \"\$screenSAVERsetting\" == \"randomvideo\" ]; then exit 0; fi
" >> /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop/impstart.sh

echo 'bash /opt/retropie/configs/imp/run-onend.sh idle &
exit 0' >> /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop/impstart.sh
chmod 755 /opt/retropie/configs/all/emulationstation/scripts/screensaver-stop/impstart.sh

#tput reset
exit 0