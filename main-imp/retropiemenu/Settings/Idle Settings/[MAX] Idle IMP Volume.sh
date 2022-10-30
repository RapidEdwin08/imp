#!/bin/bash
# mpg123 -f  "32768" # Volume % "100"
# mpg123 -f  "29484" # Volume % "90 "
# mpg123 -f  "26208" # Volume % "80 "
# mpg123 -f  "22932" # Volume % "70 "
# mpg123 -f  "19656" # Volume % "60 "
# mpg123 -f  "16380" # Volume % "50 "
# mpg123 -f  "13104" # Volume % "40 "
# mpg123 -f  "9828" # Volume % "30 "
# mpg123 -f  "6552" # Volume % "20 "
# mpg123 -f  "3276" # Volume % "10 "
# mpg123 -f  "1638" # Volume % "5  "
volumeLEVEL=32768
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings

echo "$volumeLEVEL" > $IMPSettings/lower-idle.volume

#tput reset
exit 0
