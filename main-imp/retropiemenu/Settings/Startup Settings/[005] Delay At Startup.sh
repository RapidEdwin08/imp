#!/bin/bash
delay_startup=005

IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
echo "$delay_startup" > $IMPSettings/delay-startup.flag
tput reset
exit 0
