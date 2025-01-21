#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
IMPPlaylist=$IMP/playlist
# musicDIR=$(readlink ~/RetroPie/retropiemenu/imp/music) # ES does not play well with Symbolic Links in [retropiemenu]
musicDIR=~/RetroPie/retropiemenu/imp/music
BGMdir="$musicDIR/bgm"
BGMa="$musicDIR/bgm/A-SIDE"
BGMb="$musicDIR/bgm/B-SIDE"

allMUSIC()
{
# BGM Flags AB
if [ $(cat $IMPSettings/a-side.flag) == "1" ] && [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	# Find Random [.mp3] - ALL+BGM_AB
	find "$musicDIR"/* -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf > /dev/shm/mp3.tmp
	find "$musicDIR"/*/ -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf >> /dev/shm/mp3.tmp
	cat /dev/shm/mp3.tmp | sort --random-sort > /dev/shm/pls.tmp
	randomMP3=$(cat /dev/shm/pls.tmp | shuf | tail -n 1)
	rm /dev/shm/mp3.tmp; rm /dev/shm/pls.tmp
fi

# BGM Flags A
if [ $(cat $IMPSettings/a-side.flag) == "1" ] && [ $(cat $IMPSettings/b-side.flag) == "0" ]; then
	# Find Random [.mp3] - ALL+BGM_A
	find "$musicDIR"/* -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/B-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf > /dev/shm/mp3.tmp
	find "$musicDIR"/*/ -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/B-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf >> /dev/shm/mp3.tmp
	cat /dev/shm/mp3.tmp | sort --random-sort > /dev/shm/pls.tmp
	randomMP3=$(cat /dev/shm/pls.tmp | shuf | tail -n 1)
	rm /dev/shm/mp3.tmp; rm /dev/shm/pls.tmp
fi

# BGM Flags B
if [ $(cat $IMPSettings/a-side.flag) == "0" ] && [ $(cat $IMPSettings/b-side.flag) == "1" ]; then
	# Find Random [.mp3] - ALL+BGM_B
	find "$musicDIR"/* -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/A-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf > /dev/shm/mp3.tmp
	find "$musicDIR"/*/ -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/A-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf >> /dev/shm/mp3.tmp
	cat /dev/shm/mp3.tmp | sort --random-sort > /dev/shm/pls.tmp
	randomMP3=$(cat /dev/shm/pls.tmp | shuf | tail -n 1)
	rm /dev/shm/mp3.tmp; rm /dev/shm/pls.tmp
fi

# BGM Flags ' '
if [ $(cat $IMPSettings/a-side.flag) == "0" ] && [ $(cat $IMPSettings/b-side.flag) == "0" ]; then
	# Find Random [.mp3] - ALL (NO BGM)
	find "$musicDIR"/* -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/A-SIDE/" | grep -v "/bgm/B-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf > /dev/shm/mp3.tmp
	find "$musicDIR"/*/ -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v "/bgm/A-SIDE/" | grep -v "/bgm/B-SIDE/" | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf >> /dev/shm/mp3.tmp
	cat /dev/shm/mp3.tmp | sort --random-sort > /dev/shm/pls.tmp
	randomMP3=$(cat /dev/shm/pls.tmp | shuf | tail -n 1)
	rm /dev/shm/mp3.tmp; rm /dev/shm/pls.tmp
fi
}

bgmAB()
{
# Find Random [.mp3] - BGM_AB
#randomMP3=$(find "$BGMdir"/*/ -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf | tail -n 1)
find "$BGMdir"/* -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf > /dev/shm/mp3.tmp
find "$BGMdir"/*/ -iname "*.mp3" | grep -vi .m3u | grep -vi .pls | grep -v 'imp/music/bgm/startup.mp3' | grep -v 'imp/music/bgm/quit.mp3' | grep -i .mp3 | shuf >> /dev/shm/mp3.tmp
cat /dev/shm/mp3.tmp | sort --random-sort > /dev/shm/pls.tmp
randomMP3=$(cat /dev/shm/pls.tmp | shuf | tail -n 1)
rm /dev/shm/mp3.tmp; rm /dev/shm/pls.tmp
}

m3uPLS()
{
# Find Random [.mp3] - BGM_AB
find "$musicDIR"/* -iname "*.pls" > /dev/shm/mp3.tmp
find "$musicDIR"/*/ -iname "*.pls" > /dev/shm/mp3.tmp
find "$musicDIR"/* -iname "*.m3u" >> /dev/shm/mp3.tmp
find "$musicDIR"/*/ -iname "*.m3u" >> /dev/shm/mp3.tmp
cat /dev/shm/mp3.tmp | sort --random-sort > /dev/shm/pls.tmp
randomMP3=$(cat /dev/shm/pls.tmp | shuf | tail -n 1)
rm /dev/shm/mp3.tmp; rm /dev/shm/pls.tmp
}

# Turning SHUFFLE On *202501 Changed my mind...
#echo "1" > $IMPSettings/shuffle.flag

# If Randomizer flag = 0 - Random Playlist ALL
if [ $(cat $IMPSettings/randomizer.flag) == "0" ]; then allMUSIC; fi

# If Randomizer flag = 1 - Random Playlist ALL
if [ $(cat $IMPSettings/randomizer.flag) == "1" ]; then allMUSIC; fi

# If Randomizer flag = 2 - Random Playlist BGM
if [ $(cat $IMPSettings/randomizer.flag) == "2" ]; then bgmAB; fi

# If Randomizer flag = 3 - Random Playlist PLS/M3U
if [ $(cat $IMPSettings/randomizer.flag) == "3" ]; then m3uPLS; fi

# If Random Track is EMPTY - Do Nothing
if [ "$randomMP3" == '' ]; then
	echo "COULD NOT FIND ANY TRACKS!"
	sleep 1
	exit 0
fi

# Generate new playlist around [randomMP3]
bash "$IMP/rom.sh" "$randomMP3" &
exit 0
