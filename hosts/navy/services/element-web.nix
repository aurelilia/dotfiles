{ pkgs, ... }:
let
  conf = {
    brand = "Element";
    bug_report_endpoint_url = "https://riot.im/bugreports/submit";
    defaultCountryCode = "GB";
    default_federate = true;
    default_server_config."m.homeserver" = {
      base_url = "https://matrix.elia.garden";
      server_name = "elia.garden";
    };
    default_theme = "dark";
    disable_3pid_login = true;
    disable_custom_urls = false;
    disable_guests = false;
    disable_login_language_selector = false;
    enable_presence_by_hs_url = {
      "https://matrix-client.matrix.org" = false;
      "https://matrix.org" = false;
    };
    features = {
      feature_custom_status = "labs";
      feature_custom_tags = "labs";
      feature_font_scaling = "labs";
      feature_irc_ui = "labs";
      feature_pinning = "labs";
      feature_state_counters = "labs";
    };
    integrations_rest_url = "https://scalar.vector.im/api";
    integrations_ui_url = "https://scalar.vector.im/";
    integrations_widgets_urls = [
      "https://scalar.vector.im/_matrix/integrations/v1"
      "https://scalar.vector.im/api"
      "https://scalar-staging.vector.im/_matrix/integrations/v1"
      "https://scalar-staging.vector.im/api"
      "https://scalar-staging.riot.im/scalar/api"
    ];
    jitsi.preferredDomain = "jitsi.riot.im";
    roomDirectory.servers = [ "matrix.org" ];
    settingDefaults = {
      breadcrumbs = true;
      custom_themes = [
        {
          colors = {
            accent-color = "#b4befe";
            alert = "#e5c890";
            avatar-background-colors = [
              "#89b4fa"
              "#cba6f7"
              "#a6e3a1"
            ];
            focus-bg-color = "#585b70";
            menu-selected-color = "#45475a";
            other-user-pill-bg-color = "#89dceb";
            primary-color = "#b4befe";
            reaction-row-button-selected-bg-color = "#585b70";
            room-highlight-color = "#89dceb";
            roomlist-background-color = "#181825";
            roomlist-highlights-color = "#45475a";
            roomlist-separator-color = "#7f849c";
            roomlist-text-color = "#cdd6f4";
            roomlist-text-secondary-color = "#1e1e2e";
            secondary-content = "#cdd6f4";
            sidebar-color = "#11111b";
            tertiary-content = "#cdd6f4";
            timeline-background-color = "#1e1e2e";
            timeline-highlights-color = "#181825";
            timeline-text-color = "#cdd6f4";
            timeline-text-secondary-color = "#a6adc8";
            togglesw-off-color = "#9399b2";
            username-colors = [
              "#cba6f7"
              "#eba0ac"
              "#fab387"
              "#a6e3a1"
              "#94e2d5"
              "#89dceb"
              "#74c7ec"
              "#b4befe"
            ];
            warning-color = "#f38ba8";
          };
          is_dark = true;
          name = "Catppuccin Mocha";
        }
      ];
    };
    showLabsSettings = true;
    welcomeUserId = "@riot-bot:matrix.org";
  };
in
{
  elia.caddy.routes."element.elia.garden" = {
    aliases = [ "element.louane.xyz" ];
    no-robots = true;
    extra = "respond /config.json `${builtins.toJSON conf}`";
    root = "${pkgs.element-web}";
  };
}
