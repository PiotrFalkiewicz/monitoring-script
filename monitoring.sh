#!/bin/bash




serial_id="$(cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2)"

raspivid -o - -t 0 -fps 30 -b 1000000 | ffmpeg -re -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -f h264 -i - -vcodec copy -g 50 -strict experimental -f flv rtmp://52.236.165.15:1936/camera/${serial_id}

