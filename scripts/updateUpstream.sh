#!/usr/bin/env bash

# file utilized in github actions to automatically update upstream

(
set -e
PS1="$"

current=$(cat gradle.properties | grep petalCommit | sed 's/petalCommit = //')
upstream=$(git ls-remote https://github.com/Bloom-host/Petal | grep ver/1.19.1 | cut -f 1)

if [ "$current" != "$upstream" ]; then
    sed -i 's/PetalCommit = .*/petalCommit = '"$upstream"'/' gradle.properties
    {
      ./gradlew applyPatches --stacktrace && ./gradlew build --stacktrace && ./gradlew rebuildPatches --stacktrace
    } || exit

    git add .
    ./scripts/upstreamCommit.sh "$current"
fi

) || exit 1
