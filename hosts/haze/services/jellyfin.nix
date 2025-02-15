{
  pkgs,
  ...
}:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  users.users.jellyfin.extraGroups = [ "render" ];

  feline.persist."jellyfin".path = "/var/lib/jellyfin";
  feline.caddy.routes."media.catin.eu".port = 8096;

  boot.kernelParams = [ "i915.enable_guc=2" ];
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };
}
