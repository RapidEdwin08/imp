#!/bin/bash
# Specify directory to share and Port
HTTPFolder=~/RetroPie/retropiemenu/imp/music
HTTPPort=8080

IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
bash $IMP/httpoff.sh
echo "$HTTPFolder" > $IMPSettings/http-server.dir
echo "$HTTPPort" > $IMPSettings/http-server.port
bash $IMP/httpon.sh  &
exit 0
