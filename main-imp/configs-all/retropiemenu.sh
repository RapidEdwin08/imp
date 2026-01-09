#!/bin/bash

# Added by [IMP] Integrated Media Player
# Referenced by retropiemenu from es_systems.cfg
#    <extension>.rp .sh .mp3 .MP3 .pls .PLS .m3u .M3U</extension>
#    <command>bash /opt/retropie/configs/all/retropiemenu.sh %ROM%</command>

romDIR=$(dirname "$1")
menuRP=~/RetroPie/retropiemenu
IMPmenuRP=~/RetroPie/retropiemenu/imp
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
joy2key=/opt/retropie/admin/joy2key/joy2key

function run_retropiemenu() {
	#    <command>sudo /home/pi/RetroPie-Setup/retropie_packages.sh retropiemenu launch %ROM% &lt;/dev/tty &gt; /dev/tty</command>
	# Legacy TIOCSTI is to be Disabled by Default going forward on Kernels >= 6.2 - Try Not to Use </dev/tty > /dev/tty
	if [ $(cat $IMPSettings/tiocsti-legacy.flag) == "0" ]; then
		sudo ~/RetroPie-Setup/retropie_packages.sh retropiemenu launch "$1"
	else
		sudo ~/RetroPie-Setup/retropie_packages.sh retropiemenu launch "$1" </dev/tty > /dev/tty
	fi
}

# Run .rp files as expected in the 0riginal es_systems.cfg
if [[ "$1" == *".rp" || "$1" == *".RP" ]]; then
	run_retropiemenu "$1"
	clear
	exit 0
fi

# Certain Scripts we want to use with Joypad - Launch with retropie_packages.sh retropiemenu
# *202512* use [joy2key] instead of [retropie_packages.sh retropiemenu] for quicker loading
for joyscript in 'Current Playlist.sh' 'Current Settings.sh' 'HTTP Server Log.sh' '[ReadMe] OMX Monitor.sh' \
sysinfo.sh boot-selector.sh overclock.sh screen-mode.sh gamelist-metadata-refresh.sh romsetswap.sh \
chocolate-doom_plus.sh '+Chocolate Doom Setup.sh' CacheSX2Cleaner.sh '[GIT pi-apps].sh' \
'OpenBOR - PAK Extract (v0-67).sh' 'OpenBOR PAK Extract.sh' '[QJoyPad] Desktop.sh' \
lzdoom-dazi.sh lzdoom-sijl.sh gzdoom-sijl.sh uzdoom-sijl.sh \
lr-atari800-tweaks.sh rott-darkwar_plus.sh yquake2_plus.sh \
vlc-downgrade-es.sh icon-selector.sh; do
	if [[ "$1" == *"$joyscript" ]]; then
		sudo $joy2key stop 2>/dev/null; $joy2key start
		bash "$1"
		sudo $joy2key stop 2>/dev/null
		clear
		exit 0
	fi
done

# Certain Scripts we do NOT want to use with Joypad  Simply <command>bash %ROM%</command>
for nojoyscript in 'Desktop.sh' 'Kodi.sh'; do
	if [[ "$1" == *"$nojoyscript" ]]; then
		bash "$1"
		clear
		exit 0
	fi
done

# Remaining [iMP] .sh Scripts do Not need a Joypad - Unnecessary and Slower to Launch with retropie_packages.sh retropiemenu
# If File is IN [retropiemenu/imp/*] and is .sh then Simply <command>bash %ROM%</command>
if [[ "$romDIR" == *"$IMPmenuRP"* && $1 == *".sh" ]]; then
	#     <command>bash %ROM%</command>
	bash "$1"
	clear
	exit 0
fi

# Remaining [RetroPie] .sh in [retropiemenu/*] that are NOT [iMP]
# If File is IN [retropiemenu] and is .sh then [sudo ... %ROM% > /dev/tty] files as expected in the 0riginal es_systems.cfg
if [[ "$romDIR" == *"$menuRP"* && $1 == *".sh" ]]; then
	run_retropiemenu "$1"
	clear
	exit 0
fi

# If File is NOT in [retropiemenu] (like Ports) and is .sh then Simply <command>bash %ROM%</command>
if [[ ! "$romDIR" == *"$menuRP"* && $1 == *".sh" ]]; then
	bash "$1"
	clear
	exit 0
fi

# IF .mp3 .pls .m3u then Run with [iMP]
for musicfile in .mp3 .MP3 .Mp3 .mP3 .pls .PLS .Pls .PLs .pLS .plS .m3u .M3U .m3U .M3u; do
	if [[ "$1" == *"$musicfile" ]]; then
		bash $IMP/rom.sh "$1"
		clear
		exit 0
	fi
done

exit 0
