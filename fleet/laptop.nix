{ name, nodes, config, lib, pkgs, ... }: {
  imports = [ ./workstation.nix ];

  environment.systemPackages = [ pkgs.brightnessctl ];
  services.logind = {
    powerKey = "ignore";
    hibernateKey = "ignore";
    suspendKey = "ignore";
    suspendKeyLongPress = "ignore";
    lidSwitch = "suspend";
    lidSwitchExternalPower = "ignore";
  };
  services.upower.enable = true;
}