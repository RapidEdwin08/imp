#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
echo "1" > $IMPSettings/b-side.flag

# Swap Icon of [Start All Music] + [Randomizer ALL] to Reflect BGM Settings
bash "$IMP/iconswap.sh" &

#tput reset
exit 0

