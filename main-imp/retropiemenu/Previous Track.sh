#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
bash $IMP/previous.sh > /dev/null 2>&1 && tput reset
exit 0
