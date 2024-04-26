{ lib, config, ... }:
{
  config = lib.mkIf (config.feline.tailscale.enable) {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      authKeyFile = config.age.secrets.tailscale.path;
      extraUpFlags = [
        "--login-server"
        "https://headscale.elia.garden"
        "--timeout"
        "30s"
      ];
    };

    age.secrets.tailscale.file = ../../../secrets/tailscale-preauth.age;
    feline.persist.tailscale.path = "/var/lib/tailscale";
  };

  options.feline.tailscale.enable = lib.mkEnableOption "Tailscale";
}
