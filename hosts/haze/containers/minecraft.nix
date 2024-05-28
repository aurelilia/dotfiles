{ ... }:
let
  path = "/persist/data/minecraft";
in
{
  virtualisation.oci-containers.containers.minecraft = {
    image = "itzg/minecraft-server";
    environment = {
      EULA = "TRUE";
      MEMORY = "3G";
      HI = "1";
      MOTD = "Potluck Server";
    };
    autoStart = true;
    ports = [ "25565:25565" ];
    volumes = [
      "${path}/data:/data"
      "${path}/packs:/modpacks"
    ];
  };
}
