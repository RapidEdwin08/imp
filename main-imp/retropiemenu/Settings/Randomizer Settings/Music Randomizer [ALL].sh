#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
# Enable Randomizer at Startup - ALL
echo "1" > $IMPSettings/randomizer.flag

# Update Start Randomizer Icon
rm ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
cp ~/RetroPie/retropiemenu/icons/imprandomizerall.png ~/RetroPie/retropiemenu/icons/impstartrandomizer.png

tput reset
exit 0
