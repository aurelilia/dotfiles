{ config, lib, pkgs, ... }: {
  imports = [
    ./home.nix
    ./modules/alacritty.nix
    ./modules/eww.nix
    ./modules/gtk.nix
    ./modules/mozilla.nix
    ./modules/ssh.nix
    ./modules/sway.nix
    ./modules/virt.nix
    ./modules/vscode.nix
    ./modules/xdg.nix
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
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.thunar-volman
      xfce.tumbler
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
    ];
  };
}
