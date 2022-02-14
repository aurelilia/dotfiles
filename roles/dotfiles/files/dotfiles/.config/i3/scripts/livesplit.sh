#!/bin/bash
xdotool key --window $(xdotool search --pid $(pgrep LiveSplit) --all --limit 1 --name livesplit) $@
