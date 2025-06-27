#!/bin/sh
if systemctl status keyd | rg active > /dev/null; then
    echo '{"text": "Minimak-8", "tooltip": "Click to switch to QWERTY", "class": "minimak8" }'
else
    echo '{"text": "QWERTY", "tooltip": "Click to switch to Minimak-8", "class": "qwerty" }'
fi
