# [IMP] for RetroPie
![impplaylist.png](https://raw.githubusercontent.com/RapidEdwin08/imp/main/main-imp/icons/imp/impplaylist.png )  

Based on every article you ever read about mpg123 scripts in RetroPie.  
Integrated Music Player [IMP] allows you to Select and Play [MP3/PLS/M3U] Files like a ROM.  
Automates Playlists, Recalls Last Track/Position, Next/Previous Track, Fade, INFINITE and LITE Mode.  
(No OGG Support) [Recall Last Track/Position] NOT Retained at STARTUP in LITE Mode.  

**Before you get started:**  
- Recommend your Music File *Extensions* be either ALL *lower-case* or *UPPER-CASE* for IMP `(.mp3 .MP3 .pls. PLS .m3u .M3U)`  
Results may vary using File Extensions such as`*.mP3 .Mp3 .pLs .PlS .M3u .m3U*` since Linux is cAsE-sEnSiTiVe  
- Recommend [ParseGamelistOnly] set to **OFF**, 0therwise any/all Music files not in your [gamelist.xml] will not show in ES.  
If you want to use [ParseGamelistOnly] *ON* with IMP, you will have to manually enter your Music Entries in [gamelist.xml].  

**IMP Music Folders [v2022.10]:**  
DEFAULT IMP Music Folder: *[..retropiemenu/imp/music]*  
A *Symbolic Link* to *[..roms/music]* is Created Inside the Default IMP Music Folder *[..retropiemenu/imp/music]*  
On *Install* the *[..retropiemenu/music]* Folder is Moved to *[..retropiemenu/imp/music]* *If it Exists*  
On *Uninstall* the *[../retropiemenu/imp/music]* Folder is Moved to *[..retropiemenu/music]*  

## INSTALLATION
```bash
cd ~
git clone --depth 1 https://github.com/RapidEdwin08/imp.git
sudo chmod 755 ~/imp/imp_setup.sh
cd ~/imp && ./imp_setup.sh
```

**INSTALL FLAGS** *Determines the RetroPieMenu [gamelist.xml] used @Install/Refresh*  
[STREAMS]  IMP + [mpg123] + [Streams]  
[MINIMAL]  IMP + [mpg123]  
[OFFLINE]  IMP 0nly  

**If you are [Upgrading] to a Newer Version of IMP:**  
UNINSTALL [IMP] FIRST using the SETUP Script *CURRENTLY INSTALLED*  
Then BACKUP or REMOVE the 0lder IMP Setup Folder/Files  

BACKUP the 0lder ~/imp Directory {and ~/imp-setup.tar.gz} Before Installing Newer Version of [IMP]:  
```bash
cd ~ #Change to Home Directory
mv ~/imp ~/imp-0lder #Rename 0lder [IMP] Directory
mv ~/imp-setup.tar.gz ~/imp-setup-0lder.tar.gz #Rename 0lder [IMP] tar.gz
```

To REMOVE the 0lder ~/imp Directory {and ~/imp-setup.tar.gz}:  
```bash
cd ~ #Change to Home Directory
rm ~/imp -R -f #ALWAYS PROCEED WITH CAUTION USING rm .. -R -f
rm ~/imp-setup.tar.gz
```
~~*You may need to use [sudo mv] or [sudo rm] if you used [make-install] mpg123 due to the [SOURCE] folder*~~  
v2022.10 now uses the home directory for building mpg123 from Source and Includes a Clean Source Option  

0THER BGMs ALREADY INSTALLED:  
[IMP] will attempt to Disable (NOT Remove) the following BGMs Indiscriminately upon Install:  
Livewire, BGM Naprosnia, BGM Rydra, BGM OfficialPhilcomm, Generic mpg123 Scripts  
[IMP] will attempt to Re-Enable them Upon Uninstall  
It is still Recommended you Disable your Current BGM Scripts Before Installing [IMP] If you can  

0THER RETROPIE IMAGES:  
You can install [IMP] on a range of 0ther [Non-Default] RetroPie Images  
The Installer is built to handle a small set of SUPREME Images as well  
***NO AFFILLIATION*** to SUPREME TEAM or anyone else Referenced  
You can CHECK your Non-Default RetroPie Image by Entering the CUSTOM [IMP] Menu  
If you see your Image NAME DETECTED when Entering the CUSTOM [IMP] Menu, you should NOT need the CUSTOM Installer  
It is RECOMMENDED to try the STANDARD Install First Regardless of the RetroPie Image  

CUSTOM [IMP]:  
[IMP] 0ffers a CUSTOM INSTALL that gives you the 0pportunity to Modify the Scripts before Install  
Selecting CUSTOM [IMP] will Create the Files Required for you in ~/imp/custom-imp  
You are Expected to VERIFY the Scripts in [custom-imp] and MODIFY IF NEEDED  
TEMPLATES are provided for Reference in: ~/imp/custom-imp/templates  
A README is included in the Installer for more details on [custom-imp]  

[mpg123] INSTALL UTILITIES:  
[IMP] 0ffers a range of Alternative 0ptions for installing mpg123 if needed  
This can be useful for 0lder RetroPie images with outdated repositories, or [0ffline] Installs  
The [make-install] 0ptions Provided in the [IMP] Installer have been Configured For/Tested On [Pi Zero/2/W 1/2/3/4]  
Selecting a [make-install] 0ption may take a while, and will require the [SOURCE] folder to Uninstall later  
If you choose a [make-install] 0ption and want to UNINSTALL later, DO NOT DELETE any [~/mpg123-1.x.y] Folders  
It is RECOMMENDED to use the Default method of [apt-get install] for installing mpg123 if you can  

## [IMP] RETROPIE MENU

**Music Player** [IMP]  
Current Playlist  
**./Music [~/RetroPie/retropiemenu/imp/music]**  
Previous Track  
Play  
Pause  
Stop  
Next Track  
Shuffle Off/On  
Start All Music [*BGM Settings are Respected*] {Icon Changes to Reflect BGM Settings}  
Start BGM Music  
Start Randomizer [*BGM Settings are Respected*] {Icon Changes to Reflect Randomizer Settings}  
Volume % [mpg123 Player Volume]   

**Settings**  
Current Settings  

**General Settings**  
Fade Volume Out-In [Off/On/x1/x5/x10]  
Lite Mode [Off/On]  
Infinite Mode [Off/On]  

**BGM Settings** [*Will Override Playlist at Startup*]  
BGM A-Side [Off/On] ~/RetroPie/roms/music/bgm/A-SIDE/  
BGM B-Side [Off/On] ~/RetroPie/roms/music/bgm/B-SIDE/  
Play Startup Song [Off/On] ~/RetroPie/roms/music/bgm/startup.mp3  
Play Quit Song [Off/On] ~/RetroPie/roms/music/bgm/quit.mp3  
*Both [startup.mp3/quit.mp3] are Ignored in Playlist Creation*  
*Playing Either [startup.mp3/quit.mp3] will Not Interrupt the Current Playlist*  

**Game Settings**  
Music Over Games [Off/On]  
Music Idle Over Games [Off/On] [*Respects Idle Volume Settings*]  
Delay at Game End [seconds]  

**HTTP Server** [Port:8080 You must STOP HTTP Server before you can START it on Another Directory]  
HTTP Server [Log]  
HTTP Server [On] Music Directory  
HTTP Server [On] ROMS Directory  
HTTP Server [Off]  

**Idle Settings**  
Idle at Screensaver [Off/Any/VideoOnly]  
Idle IMP Behavior at Screensaver [Stop/AdjustVolume]  
Stop IMP at Sleep [Off/On/+KillDisplay]  
Idle IMP Volume % [Volume Level when Idle]  

**OMX Monitor [BETA]**  
ReadMe OMX Monitor [Infinite L00P Script to Idle IMP at omxplayer]  
OMX Monitor [Off/On]  
Remain Idle for [seconds]  

**Randomizer Settings** [*Will Override Playlist at Startup*] {Icons Change to Reflect BGM Settings}  
Music Randomizer [Off/On]  
Randomizer Mode [All]: Pick a Random [.MP3] Track and make that sub-folder the current playlist [*BGM Settings are Respected*]  
Randomizer Mode [BGM]: Pick a Random [.MP3] Track from [BGM] and make that sub-folder the current playlist  
Randomizer Mode [PLS]: Pick a Random [.PLS/.M3U] and make it the current playlist [*Will Override BGM Settings at Startup*]  

**Startup Settings**  
Music at Startup [Off/On]  
Shuffle Playlist [Off/On]  
Delay at Startup [seconds]  

## PLAY MODES  
LITE MODE [On]: Log to TMPFS (RAM), Track Position Reset @PowerOff [Recommended for SD-Cards]  
LITE MODE [Off]: Log to File (Disk), Track Position Retained @PowerOff [**NOT** Recommended for SD-Cards]  

INFINITE MODE [On]: Infinite L00P of Current Playlist  
INFINITE MODE [Off]: Stop IMP after Finishing Current Playlist  
**NOTE:** *It is RECOMMENDED [IMP] always have MUSIC AVAILABLE to Play when using INFINITE Mode  
If you see the [HIGH TEMP ICON] at any point while attempting to Start Music - STOP [IMP]!  
[IMP] will perform various Error checks Automatically to prevent an Infinite [Error] L00P  
Should you need to STOP [IMP], Use [STOP] from [retropiemenu] OR manually bash the Stop Script:*  
```bash
bash /opt/retropie/configs/imp/stop.sh
```

## IMPORTANT

** EMULATIONSTATION FAILS TO LOAD [Assertion mType == FOLDER failed]**  
[IMP] uses the *RetroPie Menu* as it's {System} in ES Instead of adding a Custom {System} to [es_systems.cfg]  
**PROs:** avoids clogging up the "All Games" and "Favorites" Collections with MP3s (instead of ROMs)  
**CONs:** it can lead to Issues if the `[gamelist.xml]` is Corrupted and/or `[es_systems.cfg]` Contains References to File Extensions that are usually NOT in the System by Default (Similar to ScummVM)  

**Scenarios where ES may Fail to Load**:  
- `IF RetroPie is Updated leading to [es_systems.cfg] to lose the MP3/PLS/M3U extenstions needed for [IMP]`  
   *IMP now performs a check at B00T for these extenstions to avoid this issue*  
- `IF [ParseGamelistOnly] is "ON" + there are Incorrect Tags or References to File Extensions in the [gamelist.xml]`  
   *Example*:  Incorrect ~`*<game>*`~ Tags for Sub-directories in [gamelist.xml] where the **Correct Tag** should be `*<folder>*`  

**[RP/ES] + [PC/0ther] Utilities** are available in the [IMP] INSTALLER using the Same Setup Command:  
```bash
cd ~/imp && ./imp_setup.sh
```

**[RP/ES] Utilities**:  
- [ParseGamelistOnly] OFF  
- [es_systems.cfg] Repair to Fix MP3/PLS/M3Us extenstions needed for [IMP]  
- [gamelist.xml] Refresh to the State it was in after a Fresh Install of [IMP]  
- [smb.conf] Update to Add/Restore Windows (Samba) Share for [~/RetroPie/retropiemenu/imp/music]  
   For use if **Windows (Samba) Shares** are Enabled and `[../roms/music]` is N0T accessible  
   **NOTE:**  A **Windows (Samba) Share** for `[~/RetroPie/retropiemenu/imp/music]` is Added at Insall if `[smb.conf]` is present  

**[PC/0ther] Utilities**:  
- [Add/Remove] IMP [autostart.desktop] Shortcut to System Start  
- [Add/Remove] IMP [Stop.sh] Script to Emulationstation Quit  

## License
[GNU](https://www.gnu.org/licenses/gpl-3.0.en.html)
