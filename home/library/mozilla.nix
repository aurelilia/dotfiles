{
  lib,
  pkgs,
  config,
  ...
}:
{
  programs.thunderbird = {
    enable = true;
    profiles.default.isDefault = true;
    settings = {
      "privacy.donottrackheader.enabled" = true;
      "browser.download.lastDir" = "/home/leela";
    };
  };

  # Firefox seems to love resolving this link for no reason, causing the
  # activation to fail
  home.activation."Firefox is an asshole" = lib.hm.dag.entryBefore [ "installPackages" ] ''
    $DRY_RUN_CMD ${pkgs.coreutils}/bin/rm ${config.home.homeDirectory}/.mozilla/firefox/default/containers.json || true
  '';

  programs.firefox = {
    enable = true;

    policies = {
      DefaultDownloadDirectory = "/home/leela/download";
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableProfileImport = true;
      DisableTelemetry = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = false;
        Cryptomining = true;
        Fingerprinting = true;
      };
      FirefoxSuggest = false;
      NetworkPrediction = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      StartDownloadsInTempDirectory = true;
    };

    profiles.default = {
      search = {
        default = "DuckDuckGo";
        privateDefault = "DuckDuckGo";
        force = true;
        engines = {
          "Google".metaData.hidden = true;
          "Amazon".metaData.hidden = true;

          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "NixOS Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };

          "NixOS Wiki" = {
            urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nw" ];
          };

          "Noogle" = {
            urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@ng" ];
          };

          "Home-Manager Options" = {
            urls = [ { template = "https://home-manager-options.extranix.com/?query={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "hm" ];
          };
        };
      };

      userChrome = lib.readFile ../files/firefox/userChrome.css;
      userContent = lib.readFile ../files/firefox/userContent.css;
      extraConfig =
        (lib.readFile ../files/firefox/user.js) + (lib.readFile ../files/firefox/user-overrides.js);

      containers = {
        testing = {
          color = "blue";
          icon = "fruit";
        };
        work = {
          color = "red";
          icon = "cart";
          id = 1;
        };
      };
    };
  };
}
