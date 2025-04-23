{ pkgs, lib, ... }:
{
  imports = [
    ./backup.nix
    ./hardware.nix
  ];
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    (lib.hasPrefix "steam" (lib.getName pkg))
    || (lib.hasPrefix "iscan" (lib.getName pkg))
    || (lib.hasPrefix "vmware" (lib.getName pkg));

  # Extra programs
  environment.systemPackages = [
    pkgs.sonarr
    pkgs.radarr
  ];

  # Libvirt
  virtualisation.libvirtd = {
    enable = true;
    parallelShutdown = 5;
    qemu.runAsRoot = false;
  };

  # Steam.
  programs.steam.enable = true;

  # Sway configuration
  feline.gui.extraSway = {
    output = {
      HDMI-A-1 = {
        resolution = "2560x1440";
        position = "0 0";
        transform = "90";
      };
      DP-1 = {
        resolution = "3840x2160";
        position = "1440 780";
        scale = "1.5";
      };
    };

    workspaceOutputAssign = [
      {
        output = "DP-1";
        workspace = "1";
      }
      {
        output = "HDMI-A-1";
        workspace = "2";
      }
      {
        output = "DP-1";
        workspace = "3";
      }
      {
        output = "HDMI-A-1";
        workspace = "10";
      }
    ];
  };
  feline.gui.extraNiri = ''
    output "Dell Inc. DELL S2721D HK7CP43" {
        mode "2560x1440"
        position x=0 y=0
        transform "270"
    }
    output "Samsung Electric Company LU28R55 HNMW602400" {
        mode "3840x2160"
        scale 1.5
        position x=1440 y=780
    }
  '';

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
  feline.persist = {
    "bluetooth" = {
      path = "/var/lib/bluetooth";
      kind = "config";
    };
  };

  # Printer
  services.avahi.enable = true;
  services.printing = {
  	enable = true;
  	drivers = [ pkgs.ipp-usb ];
  	cups-pdf.enable = true;
  };

  # Ollama
  services.ollama = {
  	enable = true;
  	acceleration = "rocm";
  	openFirewall = true;
  	home = "/ethereal/cache/ollama";
  };
}
