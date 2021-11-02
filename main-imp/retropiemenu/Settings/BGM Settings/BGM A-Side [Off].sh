#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
echo "0" > $IMPSettings/a-side.flag

# Swap Icon of [Start All Music] to Reflect BGM Settings
rm ~/RetroPie/retropiemenu/icons/impstartall.png

if [ $(cat $IMPSettings/a-side.flag) == "0" ] && [ $(cat $IMPSettings/b-side.flag) == "0" ]; then
	cp ~/RetroPie/retropiemenu/icons/impstartalla0b0.png ~/RetroPie/retropiemenu/icons/impstartall.png
fi

if [ $(cat $IMPSettings/a-side.flag) == "1" ] && [ $(cat $IMPSettings/b-side.flag) == "0" ]; then
	cp ~/RetroPie/retropiemenu/icons/impstartalla1b0.png ~/RetroPie/retropiemenu/icons/impstartall.png
fi

if [ $(cat $IMPSettings/a-side.flag) == "0" ] && [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	cp ~/RetroPie/retropiemenu/icons/impstartalla0b1.png ~/RetroPie/retropiemenu/icons/impstartall.png
fi

if [ $(cat $IMPSettings/a-side.flag) == "1" ] && [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	cp ~/RetroPie/retropiemenu/icons/impstartalla1b1.png ~/RetroPie/retropiemenu/icons/impstartall.png
fi

tput reset
exit 0
