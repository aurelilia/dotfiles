{ config, lib, pkgs, ... }:
{
  imports = [
    ./home.nix
    ./modules/alacritty.nix
    ./modules/eww.nix
    ./modules/gtk.nix
    ./modules/ssh.nix
    ./modules/sway.nix
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
    targets.genericLinux.enable = true;

    systemd.user = {
      startServices = true;
      systemctlPath = "/usr/bin/systemctl";
    };

    xdg.configFile."nix/nix.conf".text = ''
      experimental-features = nix-command flakes
    '';
    
    home.packages = with pkgs; [
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
      (wrapWithNixGL obs-studio)
      obs-studio-plugins.input-overlay
      pavucontrol
      hotspot
      # Steam
      flatpak

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
      hyperfine
      imagemagick
      unzip
      unrar
      zip
      scc
    ];

    nixpkgs.overlays = lib.singleton (
      self: super:
      {
        wrapWithNixGL = package:
          let
            binFiles = lib.pipe "${lib.getBin package}/bin" [
              builtins.readDir
              builtins.attrNames
              (builtins.filter (n: builtins.match "^\\..*" n == null))
            ];
            wrapBin =
              name:
              self.writeShellScriptBin name ''
                exec /home/leela/.nix-profile/bin/nixGLIntel ${package}/bin/${name} "$@"
              '';
          in
          self.symlinkJoin {
            name = "${package.name}-nixgl";
            paths = (map wrapBin binFiles) ++ [ package ];
          };
      }
    );
  };
}