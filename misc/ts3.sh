#!/bin/bash

# Hacky script for patching the DarkenTS ts3 theme with catppuccin colors.
# Might report errors - `sed` commands are just from my command history when
# I did this live.

cd /opt/teamspeak3/styles
rm -r DarkenTS/Customisation/ # Causes errors due to spaces in file names, too lazy to fix
sed -i 's/29,29,29/26,24,38/g' $(rg 29,29,29 . -l)
sed -i 's/46,46,46/30,30,46/g' $(rg 46,46,46 . -l)
sed -i 's/102,102,102/87,82,104/g' $(rg 102,102,102 . -l)
sed -i 's/59,59,59/48,45,65/g' $(rg 59,59,59 . -l)
sed -i 's/34,34,34/26,24,38/g' $(rg 34,34,34 . -l)
sed -i 's/40,40,40/30,30,46/g' $(rg 40,40,40 . -l)
sed -i 's/68,68,68/48,45,65/g' $(rg 68,68,68 . -l)
sed -i 's/43,43,43/30,30,46/g' $(rg 43,43,43 . -l)
sed -i 's/23,151,81/248,189,150/g' $(rg 23,151,81 . -l)
sed -i 's/72,109,141/221,182,242/g' $(rg 72,109,141 . -l)
sed -i 's/249,101,93/242,143,173/g' $(rg 249,101,93 . -l)
