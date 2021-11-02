#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

# [pause.flag] used to Determine if Called by User[1] or Called by Script[2] from Starting a ROM
echo "1" > $IMPSettings/pause.flag

# Set [music-switch.flag]
echo "0" > $IMPSettings/music-switch.flag

# Pause mpg123
pkill -STOP mpg123 > /dev/null 2>&1

exit 0
