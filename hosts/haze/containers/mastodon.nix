{ ... }:
let
  path = "/persist/data/mastodon";
  cache = "/media/media/mastodon_cache";
  url = "social.elia.garden";

  volumes = [
    "${path}/public/system:/mastodon/public/system"
    "${cache}:/mastodon/public/system/cache"
  ];
in
{
  feline.compose.mastodon.services = {
    redis = {
      image = "redis:7-alpine";
      container_name = "mastodon-redis";
      volumes = [ "${path}/redis:/data" ];
    };
    sidekiq = {
      image = "ghcr.io/glitch-soc/mastodon:latest";
      container_name = "mastodon-sidekiq";
      command = "bundle exec sidekiq";
      depends_on = [
        "redis"
      ];
      env_file = "${path}/.env.production";
      inherit volumes;
    };
    mastodon-stream = {
      image = "ghcr.io/glitch-soc/mastodon-streaming:latest";
      command = "node ./streaming";
      depends_on = [
        "redis"
      ];
      env_file = "${path}/.env.production";
      ports = [ "127.0.0.1:40001:4000" ];
    };
    mastodon-web = {
      image = "ghcr.io/glitch-soc/mastodon:latest";
      command = "bundle exec puma -C config/puma.rb";
      depends_on = [
        "redis"
      ];
      env_file = "${path}/.env.production";
      ports = [ "127.0.0.1:30001:3000" ];
      inherit volumes;
    };
  };

  feline.caddy.routes."${url}" = {
    extra = "reverse_proxy /api/v1/streaming* localhost:40001";
    port = 30001;
  };
}
