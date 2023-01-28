#!/bin/bash
# For use with /etc/systemd/system/impquit.service

# Stop IMP - May not be required but still added here anyway
bash /opt/retropie/configs/imp/stop.sh > /dev/null 2>&1

# Do not play the quitsong if it's already found @ES Quit
if [ -f /opt/retropie/configs/all/emulationstation/scripts/quit/quitsong.sh ]; then exit 0; fi

# Play quitsong if Enabled
if [ -f /opt/retropie/configs/imp/settings/quitsong.flag ] && [ $(cat /opt/retropie/configs/imp/settings/quitsong.flag) == "1" ]; then
	mpg123 -f "$(cat /opt/retropie/configs/imp/settings/volume.flag)" "/home/pi/RetroPie/retropiemenu/imp/music/bgm/quit.mp3" > /dev/null 2>&1
fi

exit 0
