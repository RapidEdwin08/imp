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
echo "allMUSIC"
# Add all MP3s from musicROMS directory to Playlist Non-Recursive
find "$musicDIR" -maxdepth 1 -type f -name "*.mp3" > $IMPPlaylist/abc

# Add all MP3s from musicROMS SUB-directories to Playlist Recursive
find "$musicDIR"/*/ -iname "*.mp3" | grep -v 'imp/music/bgm/startup.mp3' > $IMPPlaylist/shuffle

# Remove BGM A-SIDE MP3s from musicROMS SUB-directories
cat "$IMPPlaylist/shuffle" | grep -Fv 'imp/music/bgm/A-SIDE/' > $IMPPlaylist/init
cat "$IMPPlaylist/init" > $IMPPlaylist/shuffle

# Remove BGM B-SIDE MP3s from musicROMS SUB-directories
cat "$IMPPlaylist/shuffle" | grep -Fv 'imp/music/bgm/B-SIDE/' > $IMPPlaylist/init
cat "$IMPPlaylist/init" > $IMPPlaylist/shuffle

# Sort INIT playlist with desired 0rder
cat $IMPPlaylist/abc | sort -n > $IMPPlaylist/init
cat $IMPPlaylist/shuffle | sort -n >> $IMPPlaylist/init

# Rebuild ABC and Shuffle Playlists with updated 0rder
cat $IMPPlaylist/init > $IMPPlaylist/abc
cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle
}

bgmA()
{
echo "bgmA"
# Output A-SIDE to init playlist
find $BGMa -iname "*.mp3" > $IMPPlaylist/init
cat $IMPPlaylist/init | sort -n > $IMPPlaylist/abc
cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle
}

bgmB()
{
echo "bgmB"
# Output B-SIDE to init playlist
find $BGMb -iname "*.mp3" > $IMPPlaylist/init
cat $IMPPlaylist/init | sort -n > $IMPPlaylist/abc
cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle
}

bgmAB()
{
echo "bgmAB"
# Output A-SIDE to init playlist
find $BGMa -iname "*.mp3" > $IMPPlaylist/init

# Append B-SIDE to init playlist
find $BGMb -iname "*.mp3" >> $IMPPlaylist/init

cat $IMPPlaylist/init | sort -n > $IMPPlaylist/abc
cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle
}

allMUSICbgm()
{
echo "allMUSICbgm"
# Add all MP3s from musicROMS directory to Playlist Non-Recursive
find "$musicDIR" -maxdepth 1 -type f -name "*.mp3" > $IMPPlaylist/abc

# Add all MP3s from musicROMS SUB-directories to Playlist Recursive
find "$musicDIR"/*/ -iname "*.mp3" | grep -v 'imp/music/bgm/startup.mp3' > $IMPPlaylist/shuffle

# Sort INIT playlist with desired 0rder
cat $IMPPlaylist/abc | sort -n > $IMPPlaylist/init
cat $IMPPlaylist/shuffle | sort -n >> $IMPPlaylist/init

# Rebuild ABC and Shuffle Playlists with updated 0rder
cat $IMPPlaylist/init > $IMPPlaylist/abc
cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle
}

allMUSICbgmA()
{
echo "allMUSICbgmA"
# Add all MP3s from musicROMS directory to Playlist Non-Recursive
find "$musicDIR" -maxdepth 1 -type f -name "*.mp3" > $IMPPlaylist/abc

# Add all MP3s from musicROMS SUB-directories to Playlist Recursive
find "$musicDIR"/*/ -iname "*.mp3" | grep -v 'imp/music/bgm/startup.mp3' > $IMPPlaylist/shuffle

# Remove BGM B-SIDE MP3s from musicROMS SUB-directories
cat "$IMPPlaylist/shuffle" | grep -Fv 'imp/music/bgm/B-SIDE/' > $IMPPlaylist/init
cat "$IMPPlaylist/init" > $IMPPlaylist/shuffle

# Sort INIT playlist with desired 0rder
cat $IMPPlaylist/abc | sort -n > $IMPPlaylist/init
cat $IMPPlaylist/shuffle | sort -n >> $IMPPlaylist/init

# Rebuild ABC and Shuffle Playlists with updated 0rder
cat $IMPPlaylist/init > $IMPPlaylist/abc
cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle
}

allMUSICbgmB()
{
echo "allMUSICbgmB"
# Add all MP3s from musicROMS directory to Playlist Non-Recursive
find "$musicDIR" -maxdepth 1 -type f -name "*.mp3" > $IMPPlaylist/abc

# Add all MP3s from musicROMS SUB-directories to Playlist Recursive
find "$musicDIR"/*/ -iname "*.mp3" | grep -v 'imp/music/bgm/startup.mp3' > $IMPPlaylist/shuffle

# Remove BGM A-SIDE MP3s from musicROMS SUB-directories
cat "$IMPPlaylist/shuffle" | grep -Fv 'imp/music/bgm/A-SIDE/' > $IMPPlaylist/init
cat "$IMPPlaylist/init" > $IMPPlaylist/shuffle

# Sort INIT playlist with desired 0rder
cat $IMPPlaylist/abc | sort -n > $IMPPlaylist/init
cat $IMPPlaylist/shuffle | sort -n >> $IMPPlaylist/init

# Rebuild ABC and Shuffle Playlists with updated 0rder
cat $IMPPlaylist/init > $IMPPlaylist/abc
cat $IMPPlaylist/init | sort --random-sort > $IMPPlaylist/shuffle
}

# Clear playlists
cat /dev/null > $IMPPlaylist/init
cat /dev/null > $IMPPlaylist/abc
cat /dev/null > $IMPPlaylist/shuffle

# Turning SHUFFLE On
if [[ $(cat $IMPSettings/shuffle.flag) == "0" ]]; then echo "1" > $IMPSettings/shuffle.flag; fi

# Randomizer
randomNUM=$(shuf -i 0-700 -n 1)
if [ "$randomNUM" -ge 0 ] && [ "$randomNUM" -le 100 ]; then allMUSIC; fi
if [ "$randomNUM" -ge 101 ] && [ "$randomNUM" -le 200 ]; then bgmA; fi
if [ "$randomNUM" -ge 201 ] && [ "$randomNUM" -le 300 ]; then bgmB; fi
if [ "$randomNUM" -ge 301 ] && [ "$randomNUM" -le 400 ]; then bgmAB; fi
if [ "$randomNUM" -ge 401 ] && [ "$randomNUM" -le 500 ]; then allMUSICbgm; fi
if [ "$randomNUM" -ge 501 ] && [ "$randomNUM" -le 600 ]; then allMUSICbgmA; fi
if [ "$randomNUM" -ge 601 ] && [ "$randomNUM" -le 700 ]; then allMUSICbgmB; fi

# Escape the /\slashes/\ in the Paths
ESCmusicROMS=${musicROMS//\//\\/}
ESCmusicDIR=${musicDIR//\//\\/}

# Replace rpMenu/music Path with roms/Music Path in Playlist files
sed -i s+$ESCmusicDIR+$ESCmusicROMS+ $IMPPlaylist/abc
sed -i s+$ESCmusicDIR+$ESCmusicROMS+ $IMPPlaylist/shuffle
sed -i s+$ESCmusicDIR+$ESCmusicROMS+ $IMPPlaylist/init

exit 0
