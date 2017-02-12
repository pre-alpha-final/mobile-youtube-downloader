#!/bin/bash

function ExtractVideoName
{
  VIDEONAME=$(echo "$1" | sed 's/\(.*\)_video/\1/')
  echo -e "$VIDEONAME"
  echo "" > /dev/null
}

if [ "$1" == "-h" ]
then
 echo ""
 echo SYNOPSIS
 echo " "usage $0
 echo ""
 echo DESCRIPTION
 echo "  Joins audio and video tracks with filenames ending with _audio and _video"
 echo ""
 exit
fi

#
# Joining
#
mkdir joined
FILES=$(find ./ -iname "*_video")
for file in $FILES;
do
  VIDEONAME=$(ExtractVideoName $file)
  ffmpeg -i "$VIDEONAME"_video -i "$VIDEONAME"_audio -c copy ./joined/"$VIDEONAME".mkv
done
