#!/bin/bash

_date="$(date '+%Y-%m-%d_%H:%M:%S')"
_awb="greyworld"
_fps=29
_h=720
_w=1080
_duration=120000 # 2mins

while true
do
  _date="$(date '+%Y-%m-%d_%H:%M:%S')"
  raspivid -n -vf -a "$_date" -awb $_awb -fps $_fps -h $_h -w $_w -o /home/shared/vid/"$_date".h264 -t $_duration
  /home/shared/scripts/screen_grabs.sh /home/shared/vid/"$_date".h264 &
done
