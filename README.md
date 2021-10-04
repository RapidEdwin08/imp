# IMP for RetroPie

Integrated Music Player for RetroPie. Based on every article you ever read about mpg123 scripts in RetroPie. 
Features include Recall Last Track/Position, Next/Previous Track, Select and Play MP3/PLS/M3U Files like a ROM.
Incudes Lite Mode with Limited features.

## Installation

```bash
tar xvzf imp-setup.tar.gz -C ~/
sudo chmod 755 ~/imp/imp_setup.sh
cd ~/imp && ./imp_setup.sh
```
## NOTES

WARNING: *** USE CAUTION WHEN USING INFINITE MODE ***
IMP 0ffers an INFINITE Repeat Mode which is implemented by a scripted Infinite L00P of mpg123.
Make sure you always have Musc available for IMP to Play in INFINITE Mode.
If you see the HIGH TEMP ICON at any point while attempting to Start Music - STOP IMP!
Use STOP from [retropiemenu] OR manually bash the stop script:
bash /opt/retropie/configs/imp/stop.sh

IMPORTANT: *** LITE MODE ***
IMP Writes to File for some of it's Features, such as forming Playlists when Starting Music, Recall Last Track/Position, and Previous Track.
IMP Constantly Writes the mpg123 output to a Log File to obtain Info needed for these Features.
Constantly writing to a File while Playing Music may NOT be Ideal Depending on the OS Storage type (SD Card)
IMP 0ffers a LITE Mode for this reason, which does NOT write constantly to a Log File in exchange for less features.
IN LITE Mode, the only time IMP Writes to File is upon creation of the Playlists, such as selecting an MP3, Starting ALL/BGM Music, or turning Suffle On.
If you are using an SD Card you may want to USE LITE Mode , or Enable the [Overlay File System] after setting up your Default BGM Playlist.

0THER BGMs ALREADY INSTALLED:
IMP will attempt to Disable (NOT Remove) the following BGMs Indiscriminately upon Install:
Livewire, BGM Naprosnia, BGM Rydra, BGM 0fficialPhilcomm
IMP will attempt to Re-Enable them Upon Uninstall.

0THER RETROPIE IMAGES:
You can install IMP on a range of 0ther [Non-Default] RetroPie Base Images.
The Installer is built to handle a small set of SUPREME Images and more.
***NO AFFILLIATION*** to SUPREME TEAM, MBM, or anyone else Referenced in the [Non-Default] RetroPie Images.

CUSTOM IMP:
If you are using a [Non-Default] RetroPie Base Image that is NOT listed in the Installer, IMP 0ffers a CUSTOM INSTALL.
Select CUSTOM IMP and Continue, you will be Prompted to Modify Files at a certain point..
IMP will Create a folder [imp/custom-imp] where you can manually modify the Core scripts before Install that power mpg123 for RetroPie:
 [autostart.sh] [runcommand-onend.sh] [runcommand-onstart.sh]
More 0ptional scripts are offered inside as well as templates for Reference [~/imp/custom-imp/templates].
A README is included for more details on custom-imp.

## License
[GNU](https://www.gnu.org/licenses/gpl-3.0.en.html)
