#!/usr/bin/env bash

# file utilized in github actions to automatically update upstream

(
set -e
PS1="$"

purpurHash=$(grep purpurCommit gradle.properties | sed 's/purpurCommit = //')
upstreamHash=$(git ls-remote https://github.com/PurpurMC/Purpur | grep ver/1.19.2 | cut -f 1)

if [ "$purpurHash" != "$upstreamHash" ]; then
    sed -i 's/purpurCommit = .*/purpurCommit = '"$upstreamHash"'/' gradle.properties
    {
      ./gradlew cleanCache --stacktrace && ./gradlew clean applyPatches --stacktrace && ./gradlew build --stacktrace && ./gradlew rebuildPatches --stacktrace
    } || exit

    git add .
    ./scripts/upstreamCommit.sh "$purpurHash"
fi

) || exit 1
