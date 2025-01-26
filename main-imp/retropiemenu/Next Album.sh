#!/bin/bash
IMP=/opt/retropie/configs/imp
tput reset
# Respect Repeat Mode [1] if NOT called by menu
bash "$IMP/nextalbum.sh" repeat1 &
exit 0
