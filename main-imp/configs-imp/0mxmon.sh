#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
tmpACTIVEfile=/dev/shm/0mxMonLoop.Active
omxPLAYloop=''
lowerVOLUME=$(cat $IMPSettings/lower-idle.volume)
sleepTIME=$(cat $IMPSettings/0mxmon.sleep)

echo "0mxMonLoop Activated: [$(date +%m/%d/%Y%t%H:%M:%S)]" > $tmpACTIVEfile

# Simple Shell Script L00P Uses the Existance of a [tmpACTIVEfile] FIle as the Toggle Switch
while [ -f $tmpACTIVEfile ]; do # L00P will Continue to RUN while the [$tmpACTIVEfile] File Exists
	if pgrep mpg123 > /dev/null 2>&1; then
		echo '# TMP-L00P to Wait for 0mxplayer to Start - TMP-Process will eventually close clearing 0ut built up CPU/Mem Usage in the Main Infinite L00P
while ! pgrep omxplayer > /dev/null 2>&1; do sleep 0.1; done' > /dev/shm/0mxwaitstart.sh
		sudo chmod 755 /dev/shm/0mxwaitstart.sh
		/dev/shm/0mxwaitstart.sh
		rm /dev/shm/0mxwaitstart.sh
			
			#echo 'omxplayer HAS started' + Music Player is Running # Stop Player - Set Volume Lower - Start Player
			# Stop mpg123loop WITH continue parameter
			if pgrep mpg123 > /dev/null 2>&1; then
				bash "$IMP/stop.sh" continue > /dev/null 2>&1
				#echo "$lowerVOLUME" > /dev/shm/lower-idle.volume
				echo "$(cat $IMPSettings/lower-idle.volume)"> /dev/shm/lower-idle.volume # Need to grab real-time inside the L00P if setting changed
				bash "$IMP/play.sh" & # Resume Playback
				omxPLAYloop=on
				
				while [ "$omxPLAYloop" == 'on' ]; do
					# Sub-L00P While 0mxplayer is Running
					wait $(pidof omxplayer)
				
					# Sleep Time Between Videos before breaking L00P
					#sleep 2
					sleep "$(cat $IMPSettings/0mxmon.sleep)"
					
					if ! pgrep omxplayer > /dev/null 2>&1; then
						#echo 'omxplayer NOT running - Breaking the L00P'
						omxPLAYloop=''
					fi
				done
				
				#echo 'omxplayer HAS stopped' # Stop Player - Back to Default Volume - Start Player
				# Stop mpg123loop WITH continue parameter
				bash "$IMP/stop.sh" continue > /dev/null 2>&1
				rm /dev/shm/lower-idle.volume > /dev/null 2>&1 # Remove 0ne-Time-Use Lower Volume Setting - Also Added to [mpg123loop.sh]
				bash "$IMP/play.sh" & # Resume Playback
			else
				#echo 'musicplayer NOT running'
				sleep 0.1
			fi
		#echo 'musicplayer NOT running'
		sleep 0.1
	else
		echo '# TMP-L00P to Wait for mpg123 to Start - TMP-Process will eventually close clearing 0ut built up CPU/Mem Usage in the Main Infinite L00P
while ! pgrep mpg123 > /dev/null 2>&1; do sleep 0.1; done' > /dev/shm/0mxwaitstart.sh
		sudo chmod 755 /dev/shm/0mxwaitstart.sh
		/dev/shm/0mxwaitstart.sh
		rm /dev/shm/0mxwaitstart.sh
	fi
done
exit 0
# ==============================
