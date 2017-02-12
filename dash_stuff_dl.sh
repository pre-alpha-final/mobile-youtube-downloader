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
 echo " "usage $0 URL
 echo ""
 echo DESCRIPTION
 echo "  Downloads audio and video files"
 echo ""
 exit
fi

#
# Downloading
#
LINKS=$(lynx --dump "$1" | awk '/http/{print $2}')
for link in $LINKS;
do
  FILENAME=$(ExtractFilename $link)
  wget -c -O "$FILENAME" $link;
done
