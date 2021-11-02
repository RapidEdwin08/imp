# [IMP] for RetroPie

Integrated Music Player for RetroPie. Based on every article you ever read about mpg123 scripts in RetroPie. 
Features include Recall Last Track/Position, Next/Previous Track, Select and Play MP3/PLS/M3U Files like a ROM.
Incudes LITE Mode with Limited features to Limit Writing to Disk.
eg. [Recall Last Track/Position] [Track Info] and [Previous Track] are DISABLED in LITE Mode.

## FEATURES

Music Player is Placed in RetroPie Settings Menu
Current Playlist
Previous Track [DISABLED in LITE Mode] {Icon Changes to Reflect LITE MODE}
Play
Pause
Stop
Next Track
Shuffle Off/On
Start All Music [*BGM Settings are Respected*] {Icon Changes to Reflect BGM Settings}
Start BGM Music
Volume % [mpg123 Player Volume]

Music [Place MP3/PLS/M3U Files here to have Select and Play Abilities in ES]
~/RetroPie/roms/music [symbolic link to ~/RetroPie/retropiemenu/imp/music]

Settings
Current Settings
Lite Mode [Off/On]
Infinite Mode [Off/On]

BGM Settings [*Will Override Playlist at Startup*]
BGM A-Side [Off/On] [~/RetroPie/roms/music/bgm/A-SIDE]
BGM B-Side [Off/On] [~/RetroPie/roms/music/bgm/B-SIDE]

Game Settings
Music Over Games [Off/On]
Volume Fade at Games [Off/On]
Delay at Game End [seconds]

HTTP Server [Port:8080 You must STOP HTTP Server before you can START it on Another Directory]
HTTP Server [Log]
HTTP Server [On] Music Directory
HTTP Server [On] ROMS Directory
HTTP Server [Off]

Startup Settings
Music at Startup [Off/On]
Delay at Startup [seconds]

## INSTALLATION

```bash
wget https://github.com/RapidEdwin08/imp/raw/main/imp-setup.tar.gz -P ~/
tar xvzf imp-setup.tar.gz -C ~/
sudo chmod 755 ~/imp/imp_setup.sh
cd ~/imp && ./imp_setup.sh
```

If you are Attempting an [0ffline] Install, you can to start [imp_setup.sh] with the parameter [offline] to bypass Internet Checks.
```bash
cd ~/imp && ./imp_setup.sh offline
```

If you are [Upgrading] to a Newer Version of IMP:
*UNINSTALL [IMP] FIRST using the SETUP Script CURRENTLY INSTALLED*
DELETE (or BACKUP) the 0lder [~/imp] Directory and [~/imp-setup.tar.gz] AFTER.

```bash
cd ~/imp && ./imp_setup.sh #Proceed to Uninstall 0lder [IMP]
mv ~/imp ~/imp-0lder #Rename 0lder [IMP] Directory
mv ~/imp-setup.tar.gz ~/imp-setup-0lder.tar.gz #Rename 0lder [IMP] tar.gz
```

0THER BGMs ALREADY INSTALLED:
[IMP] will attempt to Disable (NOT Remove) the following BGMs Indiscriminately upon Install:
Livewire, BGM Naprosnia, BGM Rydra, BGM OfficialPhilcomm
[IMP] will attempt to Re-Enable them Upon Uninstall.

0THER RETROPIE IMAGES:
You can install [IMP] on a range of 0ther [Non-Default] RetroPie Images.
The Installer is built to handle a small set of SUPREME Images as well.
***NO AFFILLIATION*** to SUPREME TEAM or anyone else Referenced.
You can CHECK your Non-Default RetroPie Image by Entering the CUSTOM [IMP] Menu.
If you see your Image NAME DETECTED when Entering the CUSTOM [IMP] Menu, you should NOT need the CUSTOM Installer.

CUSTOM [IMP]:
If you are using a [DEFAULT] RetroPie Image try the STANDARD Install First.
If you are using a [NON-Default] RetroPie Image [IMP] 0ffers a CUSTOM INSTALL.
With CUSTOM [IMP] you have the 0pportunity to Modify the Scripts before Install.
Selecting CUSTOM [IMP] will Create the Files Required for you in [~/imp/custom-imp]
You are Expected to VERIFY the Scripts in [custom-imp] and MODIFY IF NEEDED.
TEMPLATES are provided for Reference in: [~/imp/custom-imp/templates].
A README is included in the Installer for more details on [custom-imp].

[mpg123] INSTALL UTILITIES:
[IMP] 0ffers a range of Alternative 0ptions for installing mpg123 if needed.
This can be useful for 0lder RetroPie images with outdated repositories, or [0ffline] Installs.
The [make-install] 0ptions Provided in the [IMP] Installer have been Configured For/Tested On [Pi Zero/W 1/2/3/4].
Selecting a [make-install] 0ption may take a while, and will require the [SOURCE] folder to Uninstall later.
If you choose a [make-install] 0ption and want to UNINSTALL later, DO NOT DELETE any [~/imp/mpg123-1.x.y] Folders.
NOTE: It is RECOMMENDED to use the Default method of [apt-get install] for installing mpg123 if you can.

## IMPORTANT

LITE MODE:
[IMP] Writes to File for some of it's Features, such as forming Playlists when Starting Music, Recall Last Track/Position, and Previous Track.
[IMP] Constantly Writes the mpg123 output to a Log File to obtain Info needed for these Features.
Constantly writing to a File while Playing Music may NOT be Ideal Depending on the OS Storage type (SD Card)
[IMP] 0ffers a LITE Mode for this reason, which does NOT write constantly to a Log File in exchange for less features.
The only time [IMP] Writes to File in LITE Mode is upon creation of the Playlists, such as selecting an MP3, Starting ALL/BGM Music, or turning Suffle On.
If you are using an SD Card you may want to USE LITE Mode , or Enable the [Overlay File System] after setting up your Default BGM Playlist.

INFINITE MODE:
[IMP] 0ffers an INFINITE Repeat Mode which is implemented by a scripted Infinite L00P of mpg123.
For this reason, it is RECOMMENDED [IMP] always have MUSIC AVAILABLE to Play when using INFINITE Mode.
To prevent an EMPTY Infinite L00P, [IMP] will perform various checks and attempt to populate the Music Folders if no MP3s are found.
If you see the [HIGH TEMP ICON] at any point while attempting to Start Music - STOP [IMP]!
Use [STOP] from [retropiemenu] OR manually bash the stop script:
```bash
bash /opt/retropie/configs/imp/stop.sh
```

## License
[GNU](https://www.gnu.org/licenses/gpl-3.0.en.html)
