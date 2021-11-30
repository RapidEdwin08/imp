#!/bin/bash

# SomaFM Seasonal Stations - Check Current Date and Icon - Swap Icon accordingly [specials-400.jpg]
currentDATE=$(date +' %m%d')
currentICON=$(du -b ~/RetroPie/retropiemenu/icons/specials-400.jpg | awk '{print $1}')

# [Off Season] After 1st week in January until October
if [ "$currentDATE" -ge 0108 ] && [ "$currentDATE" -le 0930 ]; then
	# Expected Icon Size in bytes 12456 [live-400.jpg]
	if [ ! "$currentICON" == "12456" ]; then
		rm ~/RetroPie/retropiemenu/icons/specials-400.jpg
		cp ~/RetroPie/retropiemenu/icons/live-400.jpg ~/RetroPie/retropiemenu/icons/specials-400.jpg
	fi
fi

# [DOOMED] Halloween Sountrack that runs October until November 15th
if [ "$currentDATE" -ge 1001 ] && [ "$currentDATE" -le 1115 ]; then
	# Expected Icon Size in bytes 16916 [doomed-400.jpg]
	if [ ! "$currentICON" == "16916" ]; then
		rm ~/RetroPie/retropiemenu/icons/specials-400.jpg
		cp ~/RetroPie/retropiemenu/icons/doomed-400.jpg ~/RetroPie/retropiemenu/icons/specials-400.jpg
	fi
fi

# [Department Store Christmas] Holiday Sountrack that runs after November 15th until 1st week in January
if [ "$currentDATE" -ge 1116 ] && [ "$currentDATE" -le 1231 ]; then
	# Expected Icon Size in bytes 73024 [deptstorechristmas-400.jpg]
	if [ ! "$currentICON" == "73024" ]; then
		rm ~/RetroPie/retropiemenu/icons/specials-400.jpg
		cp ~/RetroPie/retropiemenu/icons/deptstorechristmas-400.jpg ~/RetroPie/retropiemenu/icons/specials-400.jpg
	fi
fi

# [Department Store Christmas] Holiday Sountrack that runs after November 15th until 1st week in January
if [ "$currentDATE" -ge 0101 ] && [ "$currentDATE" -le 0107 ]; then
	# Expected Icon Size in bytes 73024 [deptstorechristmas-400.jpg]
	if [ ! "$currentICON" == "73024" ]; then
		rm ~/RetroPie/retropiemenu/icons/specials-400.jpg
		cp ~/RetroPie/retropiemenu/icons/deptstorechristmas-400.jpg ~/RetroPie/retropiemenu/icons/specials-400.jpg
	fi
fi

# tput reset
exit 0
