#!/bin/sh
if systemctl status keyd | rg active > /dev/null; then
    sudo systemctl stop keyd
    echo '{"text": "QWERTY", "tooltip": "Click to switch to Minimak-8", "class": "qwerty" }'
else
    sudo systemctl start keyd
    echo '{"text": "Minimak-8", "tooltip": "Click to switch to QWERTY", "class": "minimak8" }'
fi
