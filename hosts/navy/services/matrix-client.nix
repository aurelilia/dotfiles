{ pkgs, ... }:
let
  element-conf = server: {
    brand = "feline chat";
    bug_report_endpoint_url = "https://riot.im/bugreports/submit";
    defaultCountryCode = "GB";
    default_federate = true;
    default_server_config."m.homeserver" = {
      base_url = "https://matrix.${server}";
      server_name = server;
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
            roomlist-text-secondary-color = "#313234";
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
        {
          colors = {
            accent-color = "#7287fd";
            alert = "#df8e1d";
            avatar-background-colors = [
              "#1e66f5"
              "#8839ef"
              "#40a02b"
            ];
            focus-bg-color = "#acb0be";
            menu-selected-color = "#bcc0cc";
            other-user-pill-bg-color = "#04a5e5";
            primary-color = "#7287fd";
            reaction-row-button-selected-bg-color = "#bcc0cc";
            room-highlight-color = "#04a5e5";
            roomlist-background-color = "#e6e9ef";
            roomlist-highlights-color = "#bcc0cc";
            roomlist-separator-color = "#8c8fa1";
            roomlist-text-color = "#4c4f69";
            roomlist-text-secondary-color = "#4c4f69";
            secondary-content = "#4c4f69";
            sidebar-color = "#dce0e8";
            tertiary-content = "#4c4f69";
            timeline-background-color = "#eff1f5";
            timeline-highlights-color = "#bcc0cc";
            timeline-text-color = "#4c4f69";
            timeline-text-secondary-color = "#6c6f85";
            togglesw-off-color = "#7c7f93";
            username-colors = [
              "#8839ef"
              "#e64553"
              "#fe640b"
              "#40a02b"
              "#179299"
              "#04a5e5"
              "#209fb5"
              "#7287fd"
            ];
            warning-color = "#d20f39";
          };
          is_dark = false;
          name = "Catppuccin Latte";
        }
      ];
    };
    showLabsSettings = true;
    welcomeUserId = "@riot-bot:matrix.org";
  };
  element = server: {
    extra = "respond /config.json `${builtins.toJSON (element-conf server)}`";
    root = "${pkgs.element-web}";
  };

  fluffy-conf =
    { server, url }:
    {
      application_name = "FluffyChat";
      application_welcome_message = "Hewwo";
      default_homeserver = server;
      web_base_url = "https://fluff.${url}/web";
      privacy_url = "https://fluff.${url}/en/privacy.html";
      render_html = false;
      hide_redacted_events = false;
      hide_unknown_events = false;
    };
  fluffy = args: {
    extra = "respond /config.json `${builtins.toJSON (fluffy-conf args)}`";
    root = "${pkgs.fluffychat-web}";
  };
in
{
  feline.caddy.routes = {
    "element.elia.garden" = element "elia.garden";
    "element.louane.xyz" = element "louane.xyz";
    "chat.feline.works" = element "elia.garden";
    "element.ehir.art" = element "ehir.art";
    "fluff.feline.works" = fluffy {
      server = "elia.garden";
      url = "feline.works";
    };
    "fluff.ehir.art" = fluffy {
      server = "ehir.art";
      url = "ehir.art";
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "fluffychat-web-1.20.0"
    "olm-3.2.16"
  ];
}
