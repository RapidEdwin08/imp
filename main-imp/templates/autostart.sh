while pgrep omxplayer >/dev/null; do sleep 1; done
bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto
emulationstation #auto
