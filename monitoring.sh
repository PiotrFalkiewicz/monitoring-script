#!/bin/bash


serial_id="$(cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2)"

if curl --fail -H "Content-Type: application/json" -X POST -d '{"serial_id":"'"$serial_id"'"}' http://52.236.165.15/v1/add_raspberry; then
	echo "Serial ID: ${serial_id} accepted by server. Starting stream to rtmp://52.236.165.15:1936/camera/${serial_id}"
	raspivid -o - -t 0 -vf -hf -fps 30 -b 1000000 | ffmpeg -re -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -strict experimental -f flv rtmp://52.236.165.15:1936/camera/${serial_id}
else
	echo "Unable to connect to server"
fi;
