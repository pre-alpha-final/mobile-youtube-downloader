#!/bin/bash

function ExtractFilename
{
  FILENAME=$(echo "$1" | sed 's/.*\&title=\(.*\)/\1/')
  echo -e "$FILENAME"
  echo "" > /dev/null
}

if [ "$1" == "" ]
then
 echo ""
 echo SYNOPSIS
 echo " "usage $0 url starting_from_x_line every_y_line
 echo ""
 echo DESCRIPTION
 echo "  Downloads audio and video files"
 echo "  The x and y parameters allow you to do something along this"
 echo "  $0 url 0 3"
 echo "  $0 url 1 3"
 echo "  $0 url 2 3"
 echo "   from 3 different terminals to have 3 concurrent downloads"
 echo ""
 exit
fi

#
# Downloading
#
LINKS=$(lynx --dump "$1" | awk '/http/{print $2}' | sed -n "$2~$3p")
for link in $LINKS;
do
  FILENAME=$(ExtractFilename $link)
  wget -c -O "$FILENAME" $link;
done
