#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
echo '1' > $IMPSettings/lower-idle.flag
#tput reset
exit 0
