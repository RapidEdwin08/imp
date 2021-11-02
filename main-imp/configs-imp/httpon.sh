#!/bin/bash
IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
HTTPFolder=$(cat $IMPSettings/http-server.dir)
httpPORT=$(cat $IMPSettings/http-server.port)
currentDATEtime=
currentIP=$(hostname -I)
currentHTTP=$(cat $IMPSettings/current.ip | tr -d "[:space:]")

echo "1" > $IMPSettings/http-server.flag

# Copy the RetroPie Logo Icon File to the current HTTP Folder if it does not already exist
if [ ! -f $HTTPFolder/favicon.ico ]; then
	cp $IMP/favicon.ico $HTTPFolder/favicon.ico 2>/dev/null
fi

# Start SimpleHTTPServer
echo "Server Started - - [ "$(date +%m/%d/%Y%t%H:%M:%S)" ]" > $IMPSettings/http-server.log
echo "Sharing Folder - - [$HTTPFolder]" >> $IMPSettings/http-server.log

cd "$HTTPFolder"
# DEPRECATION: Python 2.7 reached the end of its life on January 1st, 2020. Python2.7 is no longer maintained.
# python -m SimpleHTTPServer $httpPORT >> $IMPSettings/http-server.log 2>&1 &
python3 -m http.server $httpPORT >> $IMPSettings/http-server.log  2>&1 &
cd ~/

tput reset
exit 0
