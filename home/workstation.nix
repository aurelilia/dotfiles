{
  nixosConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  # Thank you, piegames!
  # https://git.darmstadt.ccc.de/piegames/home-config/-/blob/master/main.nix?ref_type=heads 
  wrapWithNixGL =
    package:
    let
      binFiles = lib.pipe "${lib.getBin package}/bin" [
        builtins.readDir
        builtins.attrNames
        (builtins.filter (n: builtins.match "^\\..*" n == null))
      ];
      wrapBin =
        name:
        nixosConfig.lib.pkgs-unstable.writeShellScriptBin name ''
          exec ${nixosConfig.lib.nixgl.nixGLIntel}/bin/nixGLIntel ${package}/bin/${name} "$@"
        '';
    in
    nixosConfig.lib.pkgs-unstable.symlinkJoin {
      name = "${package.name}-nixgl";
      paths = (map wrapBin binFiles) ++ [ package ];
    };
in

{
  imports = [
    ./library/alacritty.nix
    ./library/gtk.nix
    ./library/mozilla.nix
    ./library/ssh.nix
    ./library/sway.nix
    ./library/virt.nix
    ./library/vscode.nix
    ./library/waybar.nix
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
    programs = {
      mpv.enable = true;
      obs-studio = {
        enable = true;
        plugins = [ pkgs.obs-studio-plugins.input-overlay ];
      };
    };
    # Services
    services.flameshot.enable = true;
    services.ssh-agent.enable = true;

    home.packages = with pkgs; [
      # Graphical
      gnome.eog
      gnome.evince
      gnome.file-roller
      gnome.nautilus
      pavucontrol
      hotspot
      logseq
      kicad
      xournalpp
      keepassxc
      (wrapWithNixGL nixosConfig.lib.pkgs-unstable.feishin)
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
      jftui
    ];
  };
}
