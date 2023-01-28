#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

omxMONreadme=$(
echo
echo "              *** DISCLAIMER* Use at your own Risk ***"
echo
echo "  OMX Monitor is an Infinite L00P Script that Monitors for omxplayer"
echo
echo "   IMP Volume will be Adjusted when omxplayer is DETECTED Running"
echo
echo "    OMX Monitor will Resume Normal Volume when omxplayer closes"
echo
echo " You can specify the time Volume Remains @Idle Level before Resuming"
echo
echo "      NOTE: OMX Monitor Respects the Idle IMP Volume Setting"
echo
echo
echo "                       ? WHY Use OMX Monitor ? "
echo
echo "   Use to Adjust the Music Volume while Video Snaps are Playing in ES"
echo
echo " Use to Adjust the IMP Volume while RandomVideo Screensaver is Running"
echo
echo "    NOTE: Requires you ENABLE OMX in Screensaver + 0ther Settings"
echo 
)


omxM0Nflag=$(cat $IMPSettings/0mxmon.flag)
omxmonSETTING="Disabled"
omxwaitSETTING="$(cat $IMPSettings/0mxmon.sleep)"
if [ $omxM0Nflag == "1" ]; then
	omxmonSETTING="Enabled: $omxwaitSETTING"
fi

dialog --no-collapse --title "   READ ME OMX Monitor [RC1]   <  $omxmonSETTING  >    " --msgbox "$omxMONreadme"  25 75

# read -p " < OK >" </dev/tty
tput reset
exit 0
