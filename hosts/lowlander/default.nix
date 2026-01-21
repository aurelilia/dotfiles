{ lib, pkgs, ... }:
{
  imports = [
    ./backup.nix
    ./disko.nix
    ./hardware.nix
  ];

  # Generic stuff
  feline = {
    # Defaults
    autodeploy.local = true;
    tailscale.enable = true;
    theme.enable = true;
    smartd.enable = true;

    # Workstation stuff
    zfs = {
      lustrate = true;
      znap.enable = true;
    };
  };
  services.keyd.enable = lib.mkForce false;

  # Locale
  i18n.defaultLocale = lib.mkForce "de_DE.UTF-8";

  # Boot
  boot = {
    kernelParams = [ "quiet" ];
    initrd.systemd.enable = true;
    plymouth.enable = true;
  };

  # GUI
  services = {
    xserver.enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Programs
  environment.systemPackages = with pkgs; [
    libreoffice-qt6-fresh
    libsForQt5.skanlite
    vlc
  ];
  programs = {
    firefox = {
      enable = true;
      languagePacks = [ "de" ];
    };
    fish.enable = true;
  };

  # Users
  users.users =
    let
      user = name: {
        isNormalUser = true;
        shell = pkgs.fish;
        group = name;
        extraGroups = [ "wheel" ];
        hashedPassword = "$y$j9T$Cux7IceNmg8uwaZB6P0mU0$KiqsjlGnfD39Pwd21o/Au.JJpuxWwtYsWe/2Aza3EF4";
        openssh.authorizedKeys.keys = (import ../../secrets/keys.nix).ssh;
      };
    in
    {
      axel = user "axel";
      ursula = user "ursula";
    };
  users.groups = {
    axel = { };
    ursula = { };
  };

  # Printer
  services.avahi.enable = true;
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser ];
    cups-pdf.enable = true;
  };
  feline.persist."cups" = {
    path = "/var/lib/cups";
    kind = "config";
  };
}
