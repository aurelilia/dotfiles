#!/bin/sh
ICON=/usr/share/icons/Tela-purple/32/status/system-shutdown.svg

cd ~/.local/share/dotfiles

OLD_HEAD=$(git rev-parse HEAD)
git pull origin main
NEW_HEAD=$(git rev-parse HEAD)

[ $OLD_HEAD = $NEW_HEAD ] && exit 0 # Dotfiles did not change

mpv ~/.i3/scripts/notification.ogg
notify-send -u critical -i $ICON "Dotfiles changed" "Redeploying ansible playbook, please wait..." 

cat << EOF > inventory
[dotfiles]
$(hostname)
EOF
ansible-playbook -t dotfiles site.yml

mpv ~/.i3/scripts/notification.ogg
notify-send -u critical -i $ICON "Deploy finished" "Please re-login to fully apply changes."
i3-msg restart
