{ ... }:
let
  path = "/containers/drone";
  port = 50043;
  url = "ci.elia.garden";
in
{
  elia.compose.drone.services = {
    drone = {
      image = "drone/drone:2";
      env_file = [ "${path}/env" ];
      environment = [
        "DRONE_GITEA_SERVER=https://git.elia.garden"
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
      ports = [ "3000:3000" ];
      volumes = [ "/var/run/docker.sock:/var/run/docker.sock" ];
    };
  };

  elia.caddy.routes."${url}".port = port;
}
