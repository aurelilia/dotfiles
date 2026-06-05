{
  config,
  pkgs,
  ...
}:
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
    # Programs
    programs.mpv.enable = true;
    # Services
    services.ssh-agent.enable = true;
    services.jellyfin-mpv-shim.enable = true;

    home.packages = with pkgs; [
      # Graphical
      eog
      evince
      file-roller
      nautilus
      pavucontrol
      xournalpp
      keepassxc
      feishin
      orca-slicer
      video-trimmer
      gimp
      signal-desktop
      pdfarranger
      libreoffice-fresh
      wl-mirror
      ungoogled-chromium
      joplin-desktop

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
      distrobox
      elan
    ];
  };
}
