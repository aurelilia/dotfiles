{
  pkgs,
  ...
}:
{
  imports = [
    ./workstation-base.nix
  ];

  config = {
    programs.mpv.enable = true;
    services.ssh-agent.enable = true;
    services.jellyfin-mpv-shim.enable = true;

    home.packages = with pkgs; [
      # Graphical
      xournalpp
      keepassxc
      orca-slicer
      gimp
      signal-desktop
      wl-mirror
      ungoogled-chromium
      joplin-desktop

      # Desktop CLI
      distrobox
    ];
  };
}
