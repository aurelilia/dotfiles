{ ... }:
let
  url = "forge.feline.works";
in
{
  elia.containers.forgejo = {
    mounts."/var/lib/forgejo" = {
      hostPath = "/containers/forgejo/data/gitea";
      isReadOnly = false;
    };
    mounts."/etc/ssh" = {
      hostPath = "/persist/secrets/forgejo/";
      isReadOnly = false;
    };
    ports = [ { hostPort = 22; } ];

    config =
      { ... }:
      {
        networking.firewall.allowedTCPPorts = [ 3000 ];

        services.openssh = {
          enable = true;
          settings.AllowUsers = [ "git" ];
        };

        services.forgejo = {
          enable = true;
          user = "git";
          group = "git";
          database.path = "/var/lib/forgejo/gitea.db";
          settings = {
            DEFAULT = {
              APP_NAME = "feline forge";
              RUN_MODE = "prod";
            };
            server = {
              DOMAIN = url;
              SSH_USER = "git";
              SSH_DOMAIN = url;
              ROOT_URL = "https://${url}/";
            };

            avatar.PATH = "/var/lib/forgejo/avatars";
            session.PROVIDER = "file";
            security = {
              REVERSE_PROXY_TRUSTED_PROXIES = "*";
              PASSWORD_HASH_ALGO = "pbkdf2";
            };
            service = {
              DISABLE_REGISTRATION = false;
              ENABLE_NOTIFY_MAIL = false;
              ENABLE_CAPTCHA = false;
              DEFAULT_KEEP_EMAIL_PRIVATE = false;
              DEFAULT_ALLOW_CREATE_ORGANIZATION = false;
              DEFAULT_ENABLE_TIMETRACKING = false;
              NO_REPLY_ADDRESS = "";
            };
            mailer.ENABLED = false;

            ui.THEMES = "catppuccin-latte-rosewater,catppuccin-latte-flamingo,catppuccin-latte-pink,catppuccin-latte-mauve,catppuccin-latte-red,catppuccin-latte-maroon,catppuccin-latte-peach,catppuccin-latte-yellow,catppuccin-latte-green,catppuccin-latte-teal,catppuccin-latte-sky,catppuccin-latte-sapphire,catppuccin-latte-blue,catppuccin-latte-lavender,catppuccin-frappe-rosewater,catppuccin-frappe-flamingo,catppuccin-frappe-pink,catppuccin-frappe-mauve,catppuccin-frappe-red,catppuccin-frappe-maroon,catppuccin-frappe-peach,catppuccin-frappe-yellow,catppuccin-frappe-green,catppuccin-frappe-teal,catppuccin-frappe-sky,catppuccin-frappe-sapphire,catppuccin-frappe-blue,catppuccin-frappe-lavender,catppuccin-macchiato-rosewater,catppuccin-macchiato-flamingo,catppuccin-macchiato-pink,catppuccin-macchiato-mauve,catppuccin-macchiato-red,catppuccin-macchiato-maroon,catppuccin-macchiato-peach,catppuccin-macchiato-yellow,catppuccin-macchiato-green,catppuccin-macchiato-teal,catppuccin-macchiato-sky,catppuccin-macchiato-sapphire,catppuccin-macchiato-blue,catppuccin-macchiato-lavender,catppuccin-mocha-rosewater,catppuccin-mocha-flamingo,catppuccin-mocha-pink,catppuccin-mocha-mauve,catppuccin-mocha-red,catppuccin-mocha-maroon,catppuccin-mocha-peach,catppuccin-mocha-yellow,catppuccin-mocha-green,catppuccin-mocha-teal,catppuccin-mocha-sky,catppuccin-mocha-sapphire,catppuccin-mocha-blue,catppuccin-mocha-lavender";
          };
        };

        users.users.git = {
          isSystemUser = true;
          useDefaultShell = true;
          group = "git";
          home = "/var/lib/forgejo";
        };
        users.groups.git = { };
      };
  };

  elia.caddy.routes.${url} = {
    aliases = [ "git.elia.garden" ];
    host = "forgejo:3000";
  };
}
