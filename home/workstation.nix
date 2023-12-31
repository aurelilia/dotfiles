{ config, lib, pkgs, ... }: {
  imports = [
    ./home.nix
    ./modules/alacritty.nix
    ./modules/eww.nix
    ./modules/gtk.nix
    ./modules/ssh.nix
    ./modules/sway.nix
    ./modules/virt.nix
    ./modules/vscode.nix
    ./modules/xdg.nix
  ];

  config = {
    home.username = "leela";
    home.homeDirectory = "/home/${config.home.username}";
    home.file.".local/bin".source = files/bin;
    home.sessionVariables = {
      PATH = "$HOME/.local/bin:/ethereal/cache/cargo/bin:$PATH";
    };

    fonts.fontconfig.enable = true;
    programs.home-manager.enable = true;
    systemd.user.startServices = true;

    #### Misc configurations:
    # Nix
    xdg.configFile."nix/nix.conf".text = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    # Firefox
    home.activation.copyFirefox = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      cp -r $HOME/git/public/dotfiles/home/files/firefox/* ~/.mozilla/firefox/*.*/
    '';
    # Syncthing
    services.syncthing.enable = true;

    home.packages = with pkgs; [
      # Graphical
      firefox
      thunderbird
      obs-studio
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
      obs-studio-plugins.input-overlay
      pavucontrol
      hotspot
      # Steam
      flatpak

      # Fonts / Style
      fira-code-nerdfont
      dejavu_fonts
      comfortaa
      iosevka

      # Desktop CLI
      curlie
      dosfstools
      rustup
      usbutils
      yt-dlp
      wireguard-tools
      hyperfine
      imagemagick
      unzip
      unrar
      zip
      scc
    ];
  };
}
