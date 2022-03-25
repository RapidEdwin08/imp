#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# musicDIR=$(readlink ~/RetroPie/retropiemenu/imp/music) # ES does not play well with Symbolic Links in [retropiemenu]
musicDIR=~/RetroPie/retropiemenu/imp/music
musicROMS=~/RetroPie/roms/music
BGMdir="$musicDIR/bgm"
BGMa="$musicDIR/bgm/A-SIDE"
BGMb="$musicDIR/bgm/B-SIDE"

allMUSIC()
{
# BGM Flags AB
if [ $(cat $IMPSettings/a-side.flag) == "1" ] && [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	# Find Random [.mp3] - ALL+BGM_AB
	randomMP3=$(find $musicDIR -type f | grep -vi .m3u | grep -vi .pls | grep -v 'imp/music/bgm/startup.mp3' | grep -i .mp3 | shuf | tail -n 1)
fi

# BGM Flags A
if [ $(cat $IMPSettings/a-side.flag) == "1" ] && [ $(cat $IMPSettings/b-side.flag) == "0" ]; then
	# Find Random [.mp3] - ALL+BGM_A
	randomMP3=$(find $musicDIR -type f | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/B-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -i .mp3 | shuf | tail -n 1)
fi

# BGM Flags B
if [ $(cat $IMPSettings/a-side.flag) == "0" ] && [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	# Find Random [.mp3] - ALL+BGM_B
	randomMP3=$(find $musicDIR -type f | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/A-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -i .mp3 | shuf | tail -n 1)
fi

# BGM Flags ' '
if [ $(cat $IMPSettings/a-side.flag) == "0" ] && [ $(cat $IMPSettings/b-side.flag) == "0" ]; then
	# Find Random [.mp3] - ALL (NO BGM)
	randomMP3=$(find $musicDIR -type f | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/A-SIDE/" | grep -v "/bgm/B-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -i .mp3 | shuf | tail -n 1)
fi
}

bgmAB()
{
# Find Random [.mp3] - BGM_AB
randomMP3=$(find $BGMdir -type f | grep -vi .m3u | grep -vi .pls | grep -v 'imp/music/bgm/startup.mp3' | grep -i .mp3 | shuf | tail -n 1)
}

m3uPLS()
{
# Find Random [.mp3] - BGM_AB
find $musicDIR -type f | grep -i .pls > /dev/shm/pls.tmp
find $musicDIR -type f | grep -i .m3u >> /dev/shm/pls.tmp
randomMP3=$(cat /dev/shm/pls.tmp | shuf | tail -n 1)
rm /dev/shm/pls.tmp
}

# Turning SHUFFLE On
echo "1" > $IMPSettings/shuffle.flag
	
# If Randomizer flag = 1 - Random Playlist ALL
if [ $(cat $IMPSettings/randomizer.flag) == "1" ]; then allMUSIC; fi

# If Randomizer flag = 2 - Random Playlist BGM
if [ $(cat $IMPSettings/randomizer.flag) == "2" ]; then bgmAB; fi

# If Randomizer flag = 3 - Random Playlist PLS/M3U
if [ $(cat $IMPSettings/randomizer.flag) == "3" ]; then m3uPLS; fi

# If Random Track is EMPTY - Do Nothing
if [ "$randomMP3" == '' ]; then
	echo "COULD NOT FIND ANY TRACKS!"
	exit 0
fi

# Generate new playlist around [randomMP3]
bash "$IMP/rom.sh" "$randomMP3" &
exit 0
