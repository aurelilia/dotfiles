{
  name,
  lib,
  config,
  ...
}:
{
  config = (
    lib.mkMerge [
      # General config
      {
        networking = {
          hostName = name;
          fqdn = name + ".elia.garden";
          firewall.enable = lib.mkDefault true;
          extraHosts = ''
            10.0.0.1 celadon
            10.0.1.10 helio
          '';
        };
      }

      # Tailscale
      (lib.mkIf (config.elia.tailscale.enable) {
        services.tailscale = {
          enable = true;
          openFirewall = true;
          authKeyFile = config.age.secrets.tailscale.path;
          extraUpFlags = [
            "--login-server" "https://headscale.elia.garden"
            "--timeout" "30s"
          ];
        };

        age.secrets.tailscale.file = ../../secrets/tailscale-preauth.age;
        elia.persist.tailscale.path = "/var/lib/tailscale";
      })
    ]
  );

  options.elia.tailscale.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Enable Tailscale Mesh VPN";
    default = true;
  };
}
