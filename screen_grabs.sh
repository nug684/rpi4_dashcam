#!/bin/bash

_inpvid=$(echo "$1" | awk -F / '{print $5}')

ffmpeg -i "$1" -vf fps=10/60 /home/shared/pic/"$_inpvid"_%04d.jpg
