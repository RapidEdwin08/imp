#!/bin/bash

# Added by [iMP] Integrated Media Player
# Referenced by retropiemenu from es_systems.cfg
#    <extension>.rp .sh .mp3 .MP3 .pls .PLS .m3u .M3U</extension>
#    <command>bash /opt/retropie/configs/all/retropiemenu.sh %ROM%</command>

romDIR=$(dirname "$1")
menuRP=~/RetroPie/retropiemenu
IMPmenuRP=~/RetroPie/retropiemenu/imp
IMP=/opt/retropie/configs/imp

# Run .rp files as expected in the 0riginal es_systems.cfg
if [[ $1 == *".rp" ]]; then
	#    <command>sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch %ROM% &lt;/dev/tty &gt; /dev/tty</command>
	sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch "$1" </dev/tty > /dev/tty
	clear
	exit 0
fi

# Certain Scripts we want to use with Joypad - Launch with retropie_packages.sh retropiemenu
if [[ $1 == *"Current Playlist.sh" ]]; then
	#    <command>sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch %ROM% &lt;/dev/tty &gt; /dev/tty</command>
	sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch "$1" </dev/tty > /dev/tty
	clear
	exit 0
fi

# Certain Scripts we want to use with Joypad - Launch with retropie_packages.sh retropiemenu
if [[ $1 == *"Current Settings.sh" ]]; then
	#    <command>sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch %ROM% &lt;/dev/tty &gt; /dev/tty</command>
	sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch "$1" </dev/tty > /dev/tty
	clear
	exit 0
fi

# Certain Scripts we want to use with Joypad - Launch with retropie_packages.sh retropiemenu
if [[ $1 == *"HTTP Server Log.sh" ]]; then
	#    <command>sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch %ROM% &lt;/dev/tty &gt; /dev/tty</command>
	sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch "$1" </dev/tty > /dev/tty
	clear
	exit 0
fi

# Remaining [iMP] .sh Scripts do Not need a Joypad - Unnecessary and Slower to Launch with retropie_packages.sh retropiemenu
# If File is IN [retropiemenu/imp/*] and is .sh then Simply [bash %ROM%]
if [[ "$romDIR" == *"$IMPmenuRP"* && $1 == *".sh" ]]; then
	#     <command>bash %ROM%</command>
	bash "$1"
	clear
	exit 0
fi

# Remaining [RetroPie] .sh in [retropiemenu/*] that are NOT [iMP]
# If File is IN [retropiemenu] and is .sh then [sudo ... %ROM% > /dev/tty] files as expected in the 0riginal es_systems.cfg
if [[ "$romDIR" == *"$menuRP"* && $1 == *".sh" ]]; then
	#    <command>sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch %ROM% &lt;/dev/tty &gt; /dev/tty</command>
	sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch "$1" </dev/tty > /dev/tty
	clear
	exit 0
fi

# If File is NOT in [retropiemenu] (like Ports) and is .sh then Simply [bash %ROM%]
if [[ ! "$romDIR" == *"$menuRP"* && $1 == *".sh" ]]; then
	#     <command>bash %ROM%</command>
	bash "$1"
	clear
	exit 0
fi

# IF .mp3 .MP3 then Run with [iMP]
if [[ $1 == *".mp3" || $1 == *".MP3" ]]; then
	# bash "$1"
	bash $IMP/rom.sh "$1"
	clear
	exit 0
fi

# IF .pls .PLS then Run with [iMP]
if [[ $1 == *".pls" || $1 == *".PLS" ]]; then
	# bash "$1"
	bash $IMP/rom.sh "$1"
	clear
	exit 0
fi

# IF .m3u .M3U then Run with [iMP]
if [[ $1 == *".m3u" || $1 == *".M3U" ]]; then
	# bash "$1"
	bash $IMP/rom.sh "$1"
	clear
	exit 0
fi

exit 0
