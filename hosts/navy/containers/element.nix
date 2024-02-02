{ config, pkgs, ... }:
let
  element-config = ''
    {
        "default_server_config": {
            "m.homeserver": {
                "base_url": "https://matrix.elia.garden",
                "server_name": "elia.garden"
            }
        },
        "disable_custom_urls": false,
        "disable_guests": false,
        "disable_login_language_selector": false,
        "disable_3pid_login": true,
        "brand": "Element",
        "integrations_ui_url": "https://scalar.vector.im/",
        "integrations_rest_url": "https://scalar.vector.im/api",
        "integrations_widgets_urls": [
            "https://scalar.vector.im/_matrix/integrations/v1",
            "https://scalar.vector.im/api",
            "https://scalar-staging.vector.im/_matrix/integrations/v1",
            "https://scalar-staging.vector.im/api",
            "https://scalar-staging.riot.im/scalar/api"
        ],
        "bug_report_endpoint_url": "https://riot.im/bugreports/submit",
        "defaultCountryCode": "GB",
        "showLabsSettings": true,
        "features": {
            "feature_font_scaling": "labs",
            "feature_pinning": "labs",
            "feature_custom_status": "labs",
            "feature_custom_tags": "labs",
            "feature_state_counters": "labs",
            "feature_irc_ui": "labs"
        },
        "default_federate": true,
        "default_theme": "dark",
        "roomDirectory": {
            "servers": [
                "matrix.org"
            ]
        },
        "welcomeUserId": "@riot-bot:matrix.org",
        "enable_presence_by_hs_url": {
            "https://matrix.org": false,
            "https://matrix-client.matrix.org": false
        },
        "settingDefaults": {
            "breadcrumbs": true,
            "custom_themes": [
       {
            "name": "Catppuccin Purple",
            "is_dark": true,
            "colors": {
              "accent": "#ac70cc",
              "primary-color": "#DDB6F2",
              "alert": "#DDB6F2",
              "sidebar-color": "#1a1823",
              "roomlist-background-color": "#1a1823",
              "roomlist-text-color": "#D9E0EE",
              "roomlist-text-secondary-color": "#D9E0EE",
              "roomlist-highlights-color": "#00000030",
              "roomlist-separator-color": "#57526890",
              "timeline-background-color": "#1e1e2d",
              "timeline-text-color": "#D9E0EE",
              "secondary-content": "#D9E0EE",
              "tertiary-content": "#D9E0EE",
              "timeline-text-secondary-color": "#C3BAC6",
              "timeline-highlights-color": "#00000030",
              "reaction-row-button-selected-bg-color": "#988BA2"
            }
      },
      {

            "name": "Catppuccin Mocha",
            "is_dark": true,
            "colors": {
              "accent-color": "#b4befe",
              "primary-color": "#b4befe",
              "warning-color": "#f38ba8",
              "alert": "#e5c890",
              "sidebar-color": "#11111b",
              "roomlist-background-color": "#181825",
              "roomlist-text-color": "#cdd6f4",
              "roomlist-text-secondary-color": "#1e1e2e",
              "roomlist-highlights-color": "#45475a",
              "roomlist-separator-color": "#7f849c",
              "timeline-background-color": "#1e1e2e",
              "timeline-text-color": "#cdd6f4",
              "secondary-content": "#cdd6f4",
              "tertiary-content": "#cdd6f4",
              "timeline-text-secondary-color": "#a6adc8",
              "timeline-highlights-color": "#181825",
              "reaction-row-button-selected-bg-color": "#585b70",
              "menu-selected-color": "#45475a",
              "focus-bg-color": "#585b70",
              "room-highlight-color": "#89dceb",
              "togglesw-off-color": "#9399b2",
              "other-user-pill-bg-color": "#89dceb",
              "username-colors": [
                "#cba6f7",
                "#eba0ac",
                "#fab387",
                "#a6e3a1",
                "#94e2d5",
                "#89dceb",
                "#74c7ec",
                "#b4befe"
              ],
              "avatar-background-colors": [
                "#89b4fa",
                "#cba6f7",
                "#a6e3a1"
              ]
            }
          }
      ]
        },
        "jitsi": {
            "preferredDomain": "jitsi.riot.im"
        }
    }
  '';
in
{
  elia.caddy.routes."element.elia.garden" = {
    aliases = [ "element.louane.xyz" ];
    no-robots = true;
    extra = "respond /config.json `${element-config}`";
    root = "${pkgs.element-web}";
  };
}
