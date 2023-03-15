#!/bin/bash
# For use with /etc/systemd/system/impquit.service

# Stop IMP - May not be required but still added here anyway
bash /opt/retropie/configs/imp/stop.sh continue > /dev/null 2>&1

# Retain Current Track Position in LITE Mode - Grab from TMPFS and Move to DISK If Found - IMP boot.sh will Move Back to TMPFS
if [ -f /dev/shm/current-track ] && [ $(cat /opt/retropie/configs/imp/settings/lite.flag) == "1" ]; then
	# Don't Move the 0riginal [current-track] - This might be Called From ES Quit Scripts / PC Utilites
	cp /dev/shm/current-track /dev/shm/current-track.lite
	mv /dev/shm/current-track.lite /opt/retropie/configs/imp/playlist/current-track > /dev/null 2>&1
fi

# Do not play the quitsong if it's already found @ES Quit
if [ -f /opt/retropie/configs/all/emulationstation/scripts/quit/quitsong.sh ]; then exit 0; fi

# Play quitsong if Enabled
if [ -f /opt/retropie/configs/imp/settings/quitsong.flag ] && [ $(cat /opt/retropie/configs/imp/settings/quitsong.flag) == "1" ]; then
	mpg123 -f "$(cat /opt/retropie/configs/imp/settings/volume.flag)" "/home/pi/RetroPie/retropiemenu/imp/music/bgm/quit.mp3" > /dev/null 2>&1
fi

exit 0
