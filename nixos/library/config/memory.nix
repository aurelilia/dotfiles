{ lib, ... }:
{
  zramSwap.enable = true;
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    freeMemThreshold = 6;
    extraArgs = [
      "-g"
      "--prefer"
      "^(codium|cargo|java)$"
    ];
  };
  services.systembus-notify.enable = true;

  boot.kernel.sysctl = { 
    "fs.inotify.max_user_instances" = 524288; 
    "fs.inotify.max_user_watches" = 524288; 
  }; 
}
