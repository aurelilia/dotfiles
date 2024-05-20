{ ... }:
{
  zramSwap.enable = true;
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    freeMemThreshold = 6;
    extraArgs = [
      "-g"
      "--prefer '^(codium|cargo|java)$'"
    ];
  };
}
