{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    # General CLI
    apprise
    efibootmgr
    fd
    htop
    neofetch
    rsync
    openssh
    sshfs
  ] ++ lib.optionals (config.dots.kind != "server") [
    # Graphical
    (wrapWithNixGL firefox)
    (wrapWithNixGL thunderbird)
    gnome.eog
    gnome.evince
    gnome.file-roller
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
    xfce.tumbler
    flameshot
    obs-studio
    obs-studio-plugins.input-overlay
    pavucontrol
    hotspot

    # Fonts / Style
    fira-code-nerdfont
    comfortaa
    iosevka

    # Desktop CLI
    curlie
    dosfstools
    rustup
    usbutils
    yt-dlp
    wireguard-tools
  ];
}