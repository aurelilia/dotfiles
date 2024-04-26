{ ... }:
let
  path = "/persist/data/droneci";
  port = 50043;
  url = "anvil.feline.works";
in
{
  feline.compose.drone.services = {
    drone = {
      image = "drone/drone:2";
      env_file = [ "${path}/env" ];
      environment = [
        "DRONE_GITEA_SERVER=https://forge.feline.works"
        "DRONE_SERVER_HOST=${url}"
        "DRONE_SERVER_PROTO=https"
        "DRONE_USER_CREATE=username:leela,admin:true"
      ];
      ports = [ "${toString port}:80" ];
      volumes = [ "${path}/data:/data" ];
    };
    drone-runner-docker = {
      image = "drone/drone-runner-docker:1";
      env_file = [ "${path}/env" ];
      environment = [
        "DRONE_RPC_PROTO=https"
        "DRONE_RPC_HOST=${url}"
        "DRONE_RUNNER_CAPACITY=2"
        "DRONE_RUNNER_NAME=jade"
      ];
      volumes = [ "/var/run/docker.sock:/var/run/docker.sock" ];
    };
  };

  feline.caddy.routes."${url}".port = port;
}
