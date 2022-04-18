#!/bin/bash

ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')")
FILE_NAME=go1.18.1.$ARCH.tar.gz
FILE_FULL_PATH=/tmp/$FILE_NAME
rm -f $FILE_FULL_PATH
curl -o $FILE_FULL_PATH https://dl.google.com/go/$FILE_NAME
sudo rm -rf /usr/local/go && sudo rm -f /usr/local/bin/go && sudo rm -f /usr/local/bin/gofmt && tar -C /usr/local -xzf $FILE_FULL_PATH
rm -f $FILE_FULL_PATH
cp /usr/local/go/bin/go /usr/local/bin/
cp /usr/local/go/bin/gofmt /usr/local/bin/
#VAR=$(cat ~/.bash_profile | grep /usr/local/go/bin -o)
#if [[ -z $VAR ]] ; then
#    sed -i 's/PATH=\(.*\)/PATH=\1:\/usr\/local\/go\/bin/g' ~/.bash_profile
#fi

