#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
# Disable Randomizer at Startup
echo "1" > $IMPSettings/randomizerboot.flag

tput reset
exit 0
