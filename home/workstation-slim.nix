{
  nixosConfig,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./library/alacritty.nix
    ./library/dunst.nix
    ./library/gtk.nix
    ./library/mozilla.nix
    ./library/rofi.nix
    ./library/ssh.nix
    ./library/sway.nix
    ./library/vscode.nix
    ./library/waybar.nix
    ./library/xdg.nix
    ./library/zed.nix
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
    # Services
    services.flameshot.enable = true;

    home.packages = with pkgs; [
      # Graphical
      gnome.eog
      gnome.evince
      gnome.file-roller
      gnome.nautilus
      pavucontrol
      feishin

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
    ];
  };
}
