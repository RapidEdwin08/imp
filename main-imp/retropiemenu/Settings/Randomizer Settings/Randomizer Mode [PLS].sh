#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
# Enable Randomizer at Startup - PLS
echo "3" > $IMPSettings/randomizer.flag

# Update Start Randomizer Icon
rm ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
cp ~/RetroPie/retropiemenu/icons/imprandomizerpls.png ~/RetroPie/retropiemenu/icons/impstartrandomizer.png

tput reset
exit 0
