#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
# Enable Randomizer at Startup - BGM
echo "2" > $IMPSettings/randomizer.flag

# Update Start Randomizer Icon
rm ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
cp ~/RetroPie/retropiemenu/icons/imprandomizerbgm.png ~/RetroPie/retropiemenu/icons/impstartrandomizer.png

tput reset
exit 0
