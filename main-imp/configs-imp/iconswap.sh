#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

# Swap Icon of [Start All Music] + [Randomizer ALL] + [Start Randomizer] to Reflect BGM Settings
rm ~/RetroPie/retropiemenu/icons/impstartall.png
rm ~/RetroPie/retropiemenu/icons/imprandomizerall.png

if [ $(cat $IMPSettings/a-side.flag) == "0" ] && [ $(cat $IMPSettings/b-side.flag) == "0" ]; then
	cp ~/RetroPie/retropiemenu/icons/impstartalla0b0.png ~/RetroPie/retropiemenu/icons/impstartall.png
	cp ~/RetroPie/retropiemenu/icons/imprandomizeralla0b0.png ~/RetroPie/retropiemenu/icons/imprandomizerall.png
	if [ $(cat $IMPSettings/randomizer.flag) == "0" ] || [ $(cat $IMPSettings/randomizer.flag) == "1" ]; then
		rm ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
		cp ~/RetroPie/retropiemenu/icons/imprandomizeralla0b0.png ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
	fi
fi

if [ $(cat $IMPSettings/a-side.flag) == "1" ] && [ $(cat $IMPSettings/b-side.flag) == "0" ]; then
	cp ~/RetroPie/retropiemenu/icons/impstartalla1b0.png ~/RetroPie/retropiemenu/icons/impstartall.png
	cp ~/RetroPie/retropiemenu/icons/imprandomizeralla1b0.png ~/RetroPie/retropiemenu/icons/imprandomizerall.png
	if [ $(cat $IMPSettings/randomizer.flag) == "0" ] || [ $(cat $IMPSettings/randomizer.flag) == "1" ]; then
		rm ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
		cp ~/RetroPie/retropiemenu/icons/imprandomizeralla1b0.png ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
	fi
fi

if [ $(cat $IMPSettings/a-side.flag) == "0" ] && [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	cp ~/RetroPie/retropiemenu/icons/impstartalla0b1.png ~/RetroPie/retropiemenu/icons/impstartall.png
	cp ~/RetroPie/retropiemenu/icons/imprandomizeralla0b1.png ~/RetroPie/retropiemenu/icons/imprandomizerall.png
	if [ $(cat $IMPSettings/randomizer.flag) == "0" ] || [ $(cat $IMPSettings/randomizer.flag) == "1" ]; then
		rm ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
		cp ~/RetroPie/retropiemenu/icons/imprandomizeralla0b1.png ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
	fi
fi

if [ $(cat $IMPSettings/a-side.flag) == "1" ] && [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	cp ~/RetroPie/retropiemenu/icons/impstartalla1b1.png ~/RetroPie/retropiemenu/icons/impstartall.png
	cp ~/RetroPie/retropiemenu/icons/imprandomizeralla1b1.png ~/RetroPie/retropiemenu/icons/imprandomizerall.png
	if [ $(cat $IMPSettings/randomizer.flag) == "0" ] || [ $(cat $IMPSettings/randomizer.flag) == "1" ]; then
		rm ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
		cp ~/RetroPie/retropiemenu/icons/imprandomizeralla1b1.png ~/RetroPie/retropiemenu/icons/impstartrandomizer.png
	fi
fi

tput reset
exit 0
