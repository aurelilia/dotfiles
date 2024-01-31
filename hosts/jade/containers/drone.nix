{ ... }:
let
  path = "/containers/drone";
  port = "50043";
  url = "ci.elia.garden";
in
{
  elia.compose.drone.compose = ''
    services:
      drone:
        volumes:
          - "${path}/data:/data"
        environment:
          - DRONE_GITEA_SERVER=https://git.elia.garden
          - DRONE_SERVER_HOST=${url}
          - DRONE_SERVER_PROTO=https
          - DRONE_USER_CREATE=username:leela,admin:true
        env_file:
          - "/containers/drone/env"
        ports:
          - "${port}:80"
        restart: unless-stopped
        container_name: drone
        image: "drone/drone:2"

      drone-runner-docker:
        volumes:
          - "/var/run/docker.sock:/var/run/docker.sock"
        environment:
          - DRONE_RPC_PROTO=https
          - DRONE_RPC_HOST=${url}
          - DRONE_RUNNER_CAPACITY=2
          - DRONE_RUNNER_NAME=jade
        env_file:
          - "${path}/env"
        ports:
          - "3000:3000"
        restart: always
        container_name: drone-runner
        image: "drone/drone-runner-docker:1"
  '';

  elia.caddy.routes."${url}".host = "localhost:${port}";
}
