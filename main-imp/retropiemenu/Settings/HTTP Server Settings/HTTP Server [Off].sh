#!/bin/bash

IMP=/opt/retropie/configs/imp
IMPSettings=$IMP/settings
HTTPPort=$(cat $IMPSettings/http-server.port)
HTTPFolder=$(cat $IMPSettings/http-server.dir)

echo "0" > $IMPSettings/http-server.flag

# kill -9 `ps -ef | grep SimpleHTTPServer | grep 8080 | awk '{print $2}'` > /dev/null 2>&1
PIDhttp2X=$(ps -ef | grep SimpleHTTPServer | grep "$httpPORT" | awk '{print $2}')
kill -9 $PIDhttp2X > /dev/null 2>&1

PIDhttp3X=$(ps -ef | grep http.server | grep "$httpPORT" | awk '{print $2}')
kill -9 $PIDhttp3X > /dev/null 2>&1

# Remove the RetroPie Logo Icon File from the HTTP Folder
if [ -f $HTTPFolder/favicon.ico ]; then
	rm $HTTPFolder/favicon.ico 2>/dev/null
fi

# Logging
echo "Server Stopped - - [ "$(date +%m/%d/%Y%t%H:%M:%S)" ]" >> $IMPSettings/http-server.log

tput reset
exit 0
