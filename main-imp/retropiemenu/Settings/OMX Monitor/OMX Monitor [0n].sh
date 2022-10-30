#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
tmpACTIVEfile=/dev/shm/0mxMonLoop.Active

# Enable 0mxmon
echo '1' > $IMPSettings/0mxmon.flag

# kill instances of 0mxmon script
rm $tmpACTIVEfile > /dev/null 2>&1
PIDplayloop=$(ps -eaf | grep "0mxmon.sh" | awk '{print $2}')
kill $PIDplayloop > /dev/null 2>&1
rm /dev/shm/0mxwaitstart.sh > /dev/null 2>&1
bash "$IMP/0mxmon.sh" & # Start 0mxmon script

#tput reset
exit 0
