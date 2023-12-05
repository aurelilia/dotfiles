{ config, lib, pkgs, ... }:
{
  home.username = "leela";
  home.homeDirectory = "/home/leela";
  home.stateVersion = "23.11";

  home.file.".local/bin".source = files/bin;
  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$HOME/.cargo/bin:$PATH";
  };

  # Probably feishin...
  nixpkgs.config.allowUnfreePredicate = _: true;

  home.packages = with pkgs; [
    # Graphical
    (wrapWithNixGL firefox)
    (wrapWithNixGL thunderbird)
    gnome.eog
    gnome.evince
    gnome.file-roller
    gnome.simple-scan
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
    xfce.tumbler
    flameshot
    obs-studio
    obs-studio-plugins.input-overlay
    pavucontrol
    # Scanner tomfoolery
    epkowa

    # Fonts / Style
    fira-code
    fira-code-nerdfont
    comfortaa
    iosevka
    # General CLI
    apprise
    efibootmgr
    fd
    htop
    neofetch
    openssh
    sshfs

    # Desktop CLI
    curlie
    dosfstools
    rustup
    rsync
    usbutils
    yt-dlp
    wireguard-tools
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;

  imports = [
    ./modules/bat.nix
    ./modules/git.nix
    ./modules/lsd.nix
    ./modules/micro.nix
    ./modules/ssh.nix
    ./modules/starship.nix
    ./modules/zsh.nix

    ./modules/alacritty.nix
    ./modules/eww.nix
    ./modules/gtk.nix
    ./modules/sway.nix
    ./modules/xdg.nix
  ];

  systemd.user = {
    startServices = true;
    systemctlPath = "/usr/bin/systemctl";
  };

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

}
