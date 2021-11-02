#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
echo "0" > $IMPSettings/music-startup.flag
tput reset
exit 0
