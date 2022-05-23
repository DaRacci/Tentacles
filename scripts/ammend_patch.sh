#!/bin/bash

TYPE=$1
HASH=$2

if [ -f $TYPE ];then exit 1 ;fi
if [ -f $HASH ];then exit 1 ;fi

if [ $TYPE == "API" ]; then
  cd Tentacles-API
elif [[ $TYPE == "SERVER" ]]; then
  cd Tentacles-Server
else
  exit 1
fi

if [ $(git cat-file -t $HASH) != "commit" ];then exit 1; fi

git commit -a --fixup $HASH
git rebase --autosquash -i base

cd ..
./gradlew rebuildPatches
