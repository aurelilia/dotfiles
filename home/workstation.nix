{ config, pkgs, ... }:
{
  imports = [
    ./default.nix
    ./library/alacritty.nix
    ./library/eww.nix
    ./library/gtk.nix
    ./library/mozilla.nix
    ./library/ssh.nix
    ./library/sway.nix
    ./library/virt.nix
    ./library/vscode.nix
    ./library/xdg.nix
  ];

  config = {
    home.username = "leela";
    home.homeDirectory = "/home/${config.home.username}";

    fonts.fontconfig.enable = true;
    programs.home-manager.enable = true;
    systemd.user.startServices = true;

    #### Misc configurations:
    # Nix
    xdg.configFile."nix/nix.conf".text = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    # Syncthing
    services.syncthing.enable = true;
    # OBS
    programs.obs-studio = {
      enable = true;
      plugins = [ pkgs.obs-studio-plugins.input-overlay ];
    };

    home.packages = with pkgs; [
      # Graphical
      alacritty
      gnome.eog
      gnome.evince
      gnome.file-roller
      gnome.nautilus
      flameshot
      pavucontrol
      hotspot
      mpv
      # Steam
      flatpak

      # Fonts / Style
      fira-code-nerdfont
      dejavu_fonts
      comfortaa
      iosevka

      # Desktop CLI
      dosfstools
      usbutils
      yt-dlp
      wireguard-tools
      hyperfine
      imagemagick
      unzip
      zip
      scc
      sshuttle
      rustup
    ];
  };
}
