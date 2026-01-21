{ ... }:
let
  url = "zulip.catin.eu";
  data = "/persist/data/zulip";
in
{
  feline.compose.zulip = {
    services = {
      memcached = {
        command = [
          "sh"
          "-euc"
          "echo 'mech_list: plain' > \"$$SASL_CONF_PATH\"\necho \"zulip@$$HOSTNAME:$$MEMCACHED_PASSWORD\" > \"$$MEMCACHED_SASL_PWDB\"\necho \"zulip@localhost:$$MEMCACHED_PASSWORD\" >> \"$$MEMCACHED_SASL_PWDB\"\nexec memcached -S\n"
        ];
        env_file = "${data}/.env.production";
        environment = {
          MEMCACHED_SASL_PWDB = "/home/memcache/memcached-sasl-db";
          SASL_CONF_PATH = "/home/memcache/memcached.conf";
        };
        image = "memcached:alpine";
      };
      rabbitmq = {
        env_file = "${data}/.env.production";
        environment.RABBITMQ_DEFAULT_USER = "zulip";
        image = "rabbitmq:4.0.7";
        volumes = [ "${data}/rabbitmq:/var/lib/rabbitmq:rw" ];
      };
      redis = {
        env_file = "${data}/.env.production";
        command = [
          "sh"
          "-euc"
          "echo \"requirepass '$$REDIS_PASSWORD'\" > /etc/redis.conf\nexec redis-server /etc/redis.conf\n"
        ];
        image = "redis:alpine";
        volumes = [ "${data}/redis:/data:rw" ];
      };
      zulip = {
        depends_on = [
          "memcached"
          "rabbitmq"
          "redis"
        ];
        env_file = "${data}/.env.production";
        environment = {
          MANUAL_CONFIGURATION = "True";
          LINK_SETTINGS_TO_DATA = "True";
          LOADBALANCER_IPS = "0.0.0.0/0";

          SSL_CERTIFICATE_GENERATION = "self-signed";
          SETTING_EXTERNAL_HOST = url;
          DB_HOST = "host.runc.internal";
          DB_HOST_PORT = "5432";
          DB_USER = "zulip";
          SETTING_MEMCACHED_LOCATION = "memcached:11211";
          SETTING_RABBITMQ_HOST = "rabbitmq";
          SETTING_REDIS_HOST = "redis";
        };
        image = "zulip/docker-zulip:11.2-0";
        ports = [
          "34502:443"
        ];
        ulimits = {
          nofile = {
            hard = 1048576;
            soft = 1000000;
          };
        };
        volumes = [
          "${data}/zulip:/data:rw"
          "${data}/config:/data/settings/etc-zulip"
        ];
      };
    };
  };

  feline.caddy.routes."${url}".extra = ''
    reverse_proxy localhost:34502 {
      transport http {
        tls_insecure_skip_verify
      }
    }
  '';
  feline.caddy.routes."zulip.ehir.art".extra = ''
    reverse_proxy localhost:34502 {
      transport http {
        tls_insecure_skip_verify
      }
    }
  '';
}
