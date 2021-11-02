#!/bin/bash
delay_playback=20
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
echo "$delay_playback" > $IMPSettings/delay-playback.flag
tput reset
exit 0
