{ config, ... }:
let
  path = "/containers/matrix-dendrite";
  url = "matrix.louane.xyz";
  port = "51001";
in {
  # TODO
  /* elia.containers.matrix-louane = {
       mounts."/var/lib/postgres" = {
         hostPath = "${path}/postgres";
         isReadOnly = false;
       };
       mounts."/etc/dendrite" = {
         hostPath = "${path}/config";
         isReadOnly = false;
       };
       mounts."/media" = {
         hostPath = "${path}/media";
         isReadOnly = false;
       };

       config = { ... }: {
         networking.firewall.allowedTCPPorts = [ 55001 ];
         services.dendrite = {
           enable = true;
           settings = {
             global = {
               server_name = "louane.xyz";
               private_key = "/etc/dendrite/matrix_key.pem";
               database = {

               }
             };

             media_api = {
               base_path = "/media";
               max_file_size_bytes = "104857600";
             };
             sync_api.real_ip_header = "X-Real-IP";
           }
         };
       };
     };
  */

  elia.compose.matrix-louane.compose = ''
    services:
      dendrite-postgres:
        container_name: dendrite-postgres
        image: postgres:14-alpine
        restart: always
        volumes:
          - ${path}/postgres_create_db.sh:/docker-entrypoint-initdb.d/20-create_db.sh
          - ${path}/postgres:/var/lib/postgresql/data
        environment:
          POSTGRES_USER: dendrite

      dendrite:
        container_name: dendrite
        image: matrixdotorg/dendrite-monolith:latest
        volumes:
          - ${path}/config:/etc/dendrite
          - ${path}/media:/var/dendrite/media
        ports:
          - "${port}:8008"
        restart: unless-stopped
  '';

  elia.caddy.routes."${url}".host = "localhost:${port}";
}
