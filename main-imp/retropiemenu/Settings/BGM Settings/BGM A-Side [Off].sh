#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
echo "0" > $IMPSettings/a-side.flag

# Swap Icon of [Start All Music] + [Randomizer ALL] to Reflect BGM Settings
bash "$IMP/iconswap.sh" &

tput reset
exit 0
