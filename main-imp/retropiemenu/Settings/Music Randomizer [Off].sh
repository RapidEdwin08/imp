#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
# Disable Randomizer at Startup
echo "0" > $IMPSettings/randomizer.flag
tput reset
exit 0
