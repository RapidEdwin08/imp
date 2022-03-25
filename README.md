# [IMP] for RetroPie

Based on every article you ever read about mpg123 scripts in RetroPie.  
Integrated Music Player [IMP] allows you to Select and Play [MP3/PLS/M3U] Files like a ROM.  
Automates Playlists, Recalls Last Track/Position, Next/Previous Track, Fade, INFINITE and LITE Mode.  
(No OGG Support) [Recall Last Track/Position] NOT Retained at STARTUP in LITE Mode.  

**Before you get started:**  
- Recommend your Music File *Extensions* be either ALL *lower-case* or *UPPER-CASE* for IMP `(.mp3 .MP3 .pls. PLS .m3u .M3U)`  
Results may vary using File Extensions such as`*.mP3*` or `*.Mp3*` or `*.pLs*` or `*.PlS*` since Linux is cAsE-sEnSiTiVe  
- Recommend [ParseGamelistOnly] set to **OFF**, 0therwise any/all Music files not in your [gamelist.xml] will not show in ES.  
If you want to use [ParseGamelistOnly] *ON* with IMP, you will have to manually enter your Music Entries in [gamelist.xml].  

## INSTALLATION

```bash
cd ~
git clone https://github.com/RapidEdwin08/imp.git
sudo chmod 755 ~/imp/imp_setup.sh
cd ~/imp && ./imp_setup.sh
```

If you are Attempting an [0ffline] Install, you can to Start [imp_setup.sh] with the [offline] Parameter to bypass Internet Checks.  
NOTE: You can Grab the [imp-setup.tar.gz] from Releases and Extract it manually on your Device  
```bash
tar xvzf imp-setup.tar.gz -C ~/
sudo chmod 755 ~/imp/imp_setup.sh
cd ~/imp && ./imp_setup.sh offline
```

If you are [Upgrading] to a Newer Version of IMP:  
~~UNINSTALL [IMP] FIRST using the SETUP Script CURRENTLY INSTALLED~~  
*Recommend UNINSTALL using v2022.02 or Newer to avoid issues with [es_systems.cfg]*  

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
*You may need to use [sudo mv] or [sudo rm] if you used [make-install] mpg123 due to the [SOURCE] folder*  

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
A README is included in the Installer for more details on [custom-imp  

[mpg123] INSTALL UTILITIES:  
[IMP] 0ffers a range of Alternative 0ptions for installing mpg123 if needed  
This can be useful for 0lder RetroPie images with outdated repositories, or [0ffline] Installs  
The [make-install] 0ptions Provided in the [IMP] Installer have been Configured For/Tested On [Pi Zero/W 1/2/3/4]  
Selecting a [make-install] 0ption may take a while, and will require the [SOURCE] folder to Uninstall later  
If you choose a [make-install] 0ption and want to UNINSTALL later, DO NOT DELETE any [~/imp/mpg123-1.x.y] Folders  
It is RECOMMENDED to use the Default method of [apt-get install] for installing mpg123 if you can  

## [IMP] RETROPIE MENU

**Music Player** [IMP]  
Current Playlist  
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

**Music** [Place MP3/PLS/M3U Files here to have Select and Play Abilities in ES]  
~/RetroPie/roms/music [symbolic link to ~/RetroPie/retropiemenu/imp/music]  

**Settings**  
Current Settings  
Lite Mode [Off/On]  
Infinite Mode [Off/On]  
Music Randomizer Mode [Off/ALL/BGM]  

**BGM Settings** [*Will Override Playlist at Startup*]  
BGM A-Side [Off/On] ~/RetroPie/roms/music/bgm/A-SIDE/  
BGM B-Side [Off/On] ~/RetroPie/roms/music/bgm/B-SIDE/  

**Game Settings**  
Music Over Games [Off/On]  
Volume Fade at Games [Off/On]  
Delay at Game End [seconds]  

**HTTP Server** [Port:8080 You must STOP HTTP Server before you can START it on Another Directory]  
HTTP Server [Log]  
HTTP Server [On] Music Directory  
HTTP Server [On] ROMS Directory  
HTTP Server [Off]  

**Randomizer Settings** [*Will Override Playlist at Startup*] {Icons Change to Reflect BGM Settings}  
Randomizer [Off]  
Randomizer [All]: Pick a Random [.MP3] Track and make that sub-folder the current playlist [*BGM Settings are Respected*]  
Randomizer [BGM]: Pick a Random [.MP3] Track from [BGM] and make that sub-folder the current playlist  
Randomizer [PLS]: Pick a Random [.PLS/.M3U] and make it the current playlist [*Will Override BGM Settings at Startup*]  

**Startup Settings**  
Music at Startup [Off/On]  
Delay at Startup [seconds]  
Shuffle Playlist [Off/On]  
Play Startup Song [Off/On] ~/RetroPie/roms/music/bgm/startup.mp3  
NOTE: [startup.mp3] is Ignored in Playlist Creation  

## PLAY MODES  
LITE MODE: [Good for L0NG Tracks, May be N0T Recommended for SD-Cards]  
[IMP] Writes to File for it's Features, such as forming Playlists when Starting Music, Recall Last Track/Position, Previous Track  
[IMP] Constantly Writes the mpg123 output to a Log File to obtain Info needed for these Features  
Constantly writing to a File while Playing Music may NOT be Ideal Depending on the OS Storage type (SD Card)  
[IMP] 0ffers a LITE Mode for this reason, which Writes the mpg123 output to RAM Disk [tmpfs] instead for less features  
It is RECOMMENDED to use LITE MODE if you are using an SD Card, or Enable [Overlay File System] after setting your BGM Playlist  

INFINITE MODE:  
[IMP] 0ffers an INFINITE Repeat Mode which is implemented by a scripted Infinite L00P of mpg123  
For this reason, it is RECOMMENDED [IMP] always have MUSIC AVAILABLE to Play when using INFINITE Mode  
If you see the [HIGH TEMP ICON] at any point while attempting to Start Music - STOP [IMP]!  
[IMP] will perform various Error checks Automatically to prevent an Infinite [Error] L00P  
However, Should you need to STOP [IMP], Use [STOP] from [retropiemenu] OR manually bash the Stop Script:  
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

**[RP/ES] Utilities** are available in the [IMP] INSTALLER using the Same Setup Command:  
```bash
cd ~/imp && ./imp_setup.sh
```

**[RP/ES] Utilities**:  
- [ParseGamelistOnly] OFF  
- [es_systems.cfg] Repair to Fix MP3/PLS/M3Us extenstions needed for [IMP]  
- [gamelist.xml] Refresh to the State it was in after a Fresh Install of [IMP]  
- [smb.conf] Update to Add/Restore Windows (Samba) Share for [~/RetroPie/retropiemenu/imp/music]  
   For use if **Windows (Samba) Shares** are Enabled and `[../roms/music]` is N0T accessible  
   NOTE:  A **Windows (Samba) Share** for `[~/RetroPie/retropiemenu/imp/music]` is Added at Insall if `[smb.conf]` is present  

## License
[GNU](https://www.gnu.org/licenses/gpl-3.0.en.html)
