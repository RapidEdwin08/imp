#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
echo '0' > $IMPSettings/lower-idle.flag
#tput reset
exit 0
