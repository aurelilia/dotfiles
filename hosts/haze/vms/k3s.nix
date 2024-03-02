{ ... }:
{
  microvm.vms = {
    k3s-node-a = {
      config = {
        microvm.interfaces = [
          {
            type = "bridge";
            bridge = "vmbr0";
            id = "vmbr0";
            mac = "02:00:00:00:00:01";
          }
        ];

        microvm.shares = [
          {
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
            tag = "ro-store";
            proto = "virtiofs";
          }
        ];

        services.k3s.enable = true;
      };
    };
  };
}
