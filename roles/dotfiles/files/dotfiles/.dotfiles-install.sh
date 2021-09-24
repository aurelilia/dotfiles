#!/bin/bash

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -scri

yay -Syu
yay -S starship rustup fish alacritty lightdm i3-gaps pipewire firefox borg code figlet hyperfine gwenview mpv feh dunst picom-git ark lolcat micro ncdu thunar neofetch scrot flameshot noto-fonts noto-fonts-cjk ntfs-3g okular polybar tokei
yay -S wget bdf-unifont alsa-utils python-pywal i3lock-fancy-git xautolock fcitx fcitx-mozc code ttf-comfortaa lightdm-gtk-greeter lightdm-gtk-greeter-settings xorg-xinput xorg-xev pavucontrol kolourpaint bc gnupg htop nfs-utils lsd imagemagick
yay -S papirus-icon-theme xorg-server rofi lxappearance kvantum-qt pipewire-pulse pipewire-jack catia dolphin breeze ant-dracula-kvantum-theme-git qt5ct ttf-dejavu
yay -S fzf fd thefuck

rustup default stable
cargo install dotacat
cargo install zoxide

mkdir ~/.zinit
git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
