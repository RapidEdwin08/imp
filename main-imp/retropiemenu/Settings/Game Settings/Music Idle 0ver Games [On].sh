#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
echo "2" > $IMPSettings/music-over-games.flag
#tput reset
exit 0
