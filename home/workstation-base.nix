{ config, pkgs, ... }:
{
  imports = [
    ./library/alacritty.nix
    ./library/gui.nix
    ./library/mozilla.nix
    ./library/ssh.nix
    ./library/theming.nix
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

    home.packages = with pkgs; [
      # Graphical
      eog
      evince
      file-roller
      nautilus
      pavucontrol
      feishin
      video-trimmer
      pdfarranger
      libreoffice-fresh

      # Fonts / Style
      nerd-fonts.fira-code
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
