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

  # VMWare
  virtualisation.vmware.host = {
    enable = true;
    extraConfig = ''
      # Allow unsupported device's OpenGL and Vulkan acceleration for guest vGPU
      mks.gl.allowUnsupportedDrivers = "TRUE"
      mks.vk.allowUnsupportedDevices = "TRUE"
    '';
  };

  # Printer
  services.avahi.enable = true;
  services.printing = {
  	enable = true;
  	drivers = [ pkgs.ipp-usb ];
  	cups-pdf.enable = true;
  };
}
