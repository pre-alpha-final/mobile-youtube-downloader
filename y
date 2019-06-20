#!/bin/bash

function ExtractLink
{
  ENCODED1=$(echo "$WEBPAGE" | sed -e 's/,/ /g' | tr ' ' '\n' | grep "$1" | grep "$2" | sed -e 's/url=/ /g' | sed -e 's/u0026/ /g' | tr ' ' '\n' | tr -d '\\' | grep "^http")
  echo "$ENCODED1" > debug
  echo "$ENCODED1" | wc -l >> debug
  ENCODED2=$(echo "$ENCODED1" | head -n1 | sed 's/"$//')
  ENCODED3=$(wget -O- -q ###REPLACE###/trash/esc.php?url="$ENCODED2")
  echo -e "$ENCODED3" >> debug
  echo -e "$ENCODED3"
  echo "" > /dev/null
}

function ExtractSignature
{
  SIGURL=$(echo "$WEBPAGE" | sed -e 's/,/ /g' | tr ' ' '\n' | grep "$1" | grep "$2" | sed -e 's/url=/ /g')
  echo "sig1: $SIGURL" >> debug
  SIGURL=$(wget -O- -q ###REPLACE###/trash/esc.php?url="$SIGURL")
  echo "sig2: $SIGURL" >> debug
  SIGNATURE1=$(echo "$SIGURL" | sed -e 's/u0026/ /g' | sed -e 's/\&/ /g' | tr ' ' '\n' | tr -d '\\' | grep "^sig=" | grep -x '.\{80,120\}')
  echo "$SIGNATURE1" >> debug
  echo "$SIGNATURE1" | wc -l >> debug
  SIGNATURE2=$(echo "$SIGNATURE1" | sed 's/sig=\(.*\)/\1/')
  echo "$SIGNATURE2" >> debug
  SIGNATURE3=$(echo "$SIGNATURE2" | head -n1 | sed 's/"$//')
  echo "$SIGNATURE3"
  echo "" > /dev/null
}

if [ "$2" == "" ]
then
 echo ""
 echo SYNOPSIS
 echo " usage $0 a|s|m URL"
 echo ""
 exit
fi

OPTION="$1"
URL="$2"
WEBPAGE=$(wget -q -O- "$URL")
echo "$WEBPAGE" > debugWeb
FILENAME=$(echo "$WEBPAGE" | grep "<meta name=\"title\"" | sed -e "s/.*content=\"\(.*\)\".*/\1/" | sed -e "s/&quot;//g" | sed -e "s/&#39;/_/g"\
           | tr ":" "_" | tr "(" "_" | tr ")" "_" | tr "[" "_" | tr "]" "_" | tr " " "_" | tr "?" "_" | tr '\\' "_" | tr "/" "_" | tr "|" "_" | tr "\*" "_")
LINK=""
if [ "$LINK" == "" ]
then
  if [ "$OPTION" == "a" ]
  then
    LINK=$(ExtractLink audio mp4)
    SCRAMBLEDSIGNATURE=$(ExtractSignature audio mp4)
  fi
  if [ "$OPTION" == "s" ]
  then
    LINK=$(ExtractLink =small mp4)
    SCRAMBLEDSIGNATURE=$(ExtractSignature =small mp4)
  fi
  if [ "$OPTION" == "m" ]
  then
    LINK=$(ExtractLink =medium mp4)
    SCRAMBLEDSIGNATURE=$(ExtractSignature =medium mp4)
  fi
  if [ "$OPTION" == "hd720" ]
  then
    LINK=$(ExtractLink =hd720 mp4)
    SCRAMBLEDSIGNATURE=$(ExtractSignature =hd720 mp4)
  fi
fi

echo "<script>document.write(\"<a href=\\\"$LINK&sig=\");" >> links.htm
echo "var rrsignature = encodeURIComponent(decodeURIComponent(Bv(\"$SCRAMBLEDSIGNATURE\")));" >> links.htm
echo "document.write(rrsignature);" >> links.htm
echo "document.write(\"&title=$FILENAME\");" >> links.htm
echo "document.write(\"\\\">$FILENAME</a></br>\");</script>" >> links.htm
