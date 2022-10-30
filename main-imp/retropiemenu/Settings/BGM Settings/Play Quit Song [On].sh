#!/bin/bash

# Create ES Scripts Folder
mkdir /opt/retropie/configs/all/emulationstation/scripts > /dev/null 2>&1

# Enable quit.mp3 IMP @ESQuit
mkdir /opt/retropie/configs/all/emulationstation/scripts/quit > /dev/null 2>&1
echo '#!/bin/bash' > /opt/retropie/configs/all/emulationstation/scripts/quit/quitsong.sh
echo 'mpg123 -f "$(cat /opt/retropie/configs/imp/settings/volume.flag)" "$HOME/RetroPie/retropiemenu/imp/music/bgm/quit.mp3" > /dev/null 2>&1' >> /opt/retropie/configs/all/emulationstation/scripts/quit/quitsong.sh
echo 'exit 0' >> /opt/retropie/configs/all/emulationstation/scripts/quit/quitsong.sh
sudo chmod 755 /opt/retropie/configs/all/emulationstation/scripts/quit/quitsong.sh

#tput reset
exit 0
