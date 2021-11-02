#!/usr/bin/env bash
echo ""
echo "Switching default boot to Emulation Station and rebooting"
echo ""
sleep 5
echo "#/home/pi/scripts/themerandom.sh" > /opt/retropie/configs/all/autostart.sh
echo "while pgrep omxplayer >/dev/null; do sleep 1; done" >> /opt/retropie/configs/all/autostart.sh
echo 'bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto' >> /opt/retropie/configs/all/autostart.sh
echo "emulationstation #auto" >> /opt/retropie/configs/all/autostart.sh
cp /opt/RetroFlag/SafeShutdown.py.es /opt/RetroFlag/SafeShutdown.py
sudo reboot