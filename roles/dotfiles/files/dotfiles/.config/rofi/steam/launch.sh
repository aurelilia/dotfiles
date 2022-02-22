#!/usr/bin/env bash

cd $(dirname $(realpath $0))

GAME_LAUNCHER_CACHE=$HOME/.cache/rofi-game-launcher

./update-game-entries.sh -q &

(
    # Temporarily overwrite XDG_DATA_HOME so that Rofi looks for
    # .desktop files in $GAME_LAUNCHER/applications instead of
    # ~/.local/share/applications
    export XDG_DATA_HOME=$GAME_LAUNCHER_CACHE
    rofi -show drun -theme games -drun-categories SteamLibrary \
            -cache-dir $GAME_LAUNCHER_CACHE
)

# Emulate most recently used history by resetting the count
# to 0 for each application
sed -i -e 's/^1/0/' $GAME_LAUNCHER_CACHE/rofi3.druncache
