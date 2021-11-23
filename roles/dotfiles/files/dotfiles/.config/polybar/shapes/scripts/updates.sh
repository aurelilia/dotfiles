#!/usr/bin/env bash
echo " $(pacman -Qu --dbpath "/tmp/pacman_db" 2>/dev/null | wc -l)"
