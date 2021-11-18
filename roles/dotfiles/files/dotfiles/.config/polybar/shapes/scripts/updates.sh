#!/usr/bin/env bash
echo " $(pacman -Qu 2>/dev/null | wc -l)"
