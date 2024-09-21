{ ... }: {
  feline.compose.code.services.code = {
    image = "lscr.io/linuxserver/code-server:latest";
    container_name = "code-server";
    environment = {
      "PUID" = "1000";
      "PGID" = "1000";
      "TZ" = "Etc/UTC";
      "HASHED_PASSWORD" = "$$argon2i$$v=19$$m=4096,t=3,p=1$$ZHJqaG5lYmpudmJuem9ndA$$3GbFWpZ+IUT+Iu8LVKNphEPqyqf1+rlybnmwLweNDvY";
      "DEFAULT_WORKSPACE" = "/config/workspace";
    };
    ports = [ "127.0.0.1:4444:8443" ];
    volumes = [ "/media/personal/code-server:/config" ];
  };

  feline.caddy.routes."berg.ehir.art" = {
    mode = "local";
    port = 4444;
  };
}
