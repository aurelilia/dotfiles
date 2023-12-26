let uris = [ "qemu+ssh://root@haze/system" ];
in { config, pkgs, lib, ... }: {
  home.packages = with pkgs; [ virt-manager dconf ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      inherit uris;
      autoconnect = uris;
    };
  };
}
