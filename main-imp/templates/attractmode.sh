#!/usr/bin/env bash
echo ""
echo "Switching default boot to Attract Mode and rebooting"
echo ""
sleep 5
echo "while pgrep omxplayer >/dev/null; do sleep 1; done" > /opt/retropie/configs/all/autostart.sh
echo "#/home/pi/.attract/ambootcheck/amromcheck.sh" >> /opt/retropie/configs/all/autostart.sh 
echo "attract #auto" >> /opt/retropie/configs/all/autostart.sh
cp /opt/RetroFlag/SafeShutdown.py.attract /opt/RetroFlag/SafeShutdown.py
sudo reboot
