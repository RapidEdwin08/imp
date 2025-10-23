#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

# [pause.flag] used to Determine if Called by User[1] or Called by Script[2] from Starting a ROM
echo "1" > $IMPSettings/pause.flag

# Set [music-switch.flag]
echo "0" > $IMPSettings/music-switch.flag

# Stop 0mxmon while paused
#if [ $(cat /opt/retropie/configs/imp/settings/0mxmon.flag) == "1" ]; then
	#rm /dev/shm/0mxMonLoop.Active > /dev/null 2>&1
	#rm /dev/shm/0mxwaitstart.sh > /dev/null 2>&1
	# kill instances of 0mxmon script
	#PIDplayloop=$(ps -eaf | grep "0mxmon.sh" | awk '{print $2}')
	#kill $PIDplayloop > /dev/null 2>&1
#fi

# Pause mpg123
pkill -STOP mpg123 > /dev/null 2>&1

exit 0
