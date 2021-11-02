#isdual=`tvservice -l |grep "2 attached device" |wc -l`
if [[ $isdual == "1" ]]; then
fbset -fb /dev/fb0 -g 1920 1080 1920 1080 16
/usr/bin/python /opt/retropie/configs/all/PieMarquee2/PieMarquee2.py &
fi
#/home/pi/.attract/ambootcheck/amromcheck.sh
# Do NOT Add/Uncomment unless you want [IMP] to run at Startup in AttractMode
#bash /opt/retropie/configs/imp/boot.sh > /dev/null 2>&1 &
attract #auto
