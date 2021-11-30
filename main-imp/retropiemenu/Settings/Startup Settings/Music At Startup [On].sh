#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
echo "1" > $IMPSettings/music-startup.flag

# Check for [IMP] Files/Folders Linked to [retropiemenu] [gamelist.xml]
# Create Files/Folders If Needed to Prevent ERROR [Assertion `mType == FLODER' failed]
bash "$IMP/rpmenucheck.sh" > /dev/null 2>&1

# v2021.11 Addition - Runs at [IMP] install + Runs here in case of [RetroPie-Setup] Scripts gets Updated
rpsKODIautostart=~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh
rpsKODI='echo -e \"kodi #auto\\nemulationstation #auto\" >>\"$script\"'
rpsKODIsa='echo -e \"kodi-standalone #auto\\nemulationstation #auto\" >>\"$script\"'
rpsKODIes='echo \"emulationstation #auto\" >>\"$script\"'
impKODI='echo -e \"kodi #auto\\nbash \/opt\/retropie\/configs\/imp\/boot.sh > \/dev\/null 2>\&1 \& #auto\\nemulationstation #auto\" >>\"$script\"'
impKODIsa='echo -e \"kodi-standalone #auto\\nbash \/opt\/retropie\/configs\/imp\/boot.sh > \/dev\/null 2>\&1 \& #auto\\nemulationstation #auto\" >>\"$script\"'
impKODIes='echo -e \"bash \/opt\/retropie\/configs\/imp\/boot.sh > \/dev\/null 2>\&1 \& #auto\\nemulationstation #auto\" >>\"$script\"'

# Modifications to Retain [IMP] when Switching ES/Kodi on Boot from RetroPie-Setup
# --- [Default] [~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh]  ---
#            echo -e "kodi #auto\nemulationstation #auto" >>"$script"
#            echo -e "kodi-standalone #auto\nemulationstation #auto" >>"$script"
#            echo "emulationstation #auto" >>"$script"

# --- [IMP] [~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh]  ---
#            echo -e "kodi #auto\nbash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto\nemulationstation #auto" >>"$script"
#            echo -e "kodi-standalone #auto\nbash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto\nemulationstation #auto" >>"$script"
#            echo -e "bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 & #auto\nemulationstation #auto" >>"$script"

# Add [IMP] to the Auto-start ES/Kodi on Boot Script [~/RetroPie-Setup/scriptmodules/supplementary/autostart.sh]
sed -i s+"$rpsKODI"+"$impKODI"+ $rpsKODIautostart
sed -i s+"$rpsKODIsa"+"$impKODIsa"+ $rpsKODIautostart
sed -i s+"$rpsKODIes"+"$impKODIes"+ $rpsKODIautostart

tput reset
exit 0
