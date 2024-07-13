# https://github.com/nix-community/home-manager/pull/5455
{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}:
let
  cfg = config.programs.zed-editor;
  jsonFormat = pkgs.formats.json { };

  mergedSettings = cfg.userSettings // {
    # this part by @cmacrae
    auto_install_extensions = lib.listToAttrs (map (ext: lib.nameValuePair ext true) cfg.extensions);
  };
in
{
  config = {
    home.packages = [ nixosConfig.lib.pkgs-unstable.zed-editor ];
    xdg.configFile."zed/settings.json".source = jsonFormat.generate "zed-user-settings" mergedSettings;
    xdg.configFile."zed/keymap.json".source = jsonFormat.generate "zed-user-keymaps" cfg.userKeymaps;

    programs.zed-editor = {
      userSettings = {
        base_keymap = "VSCode";
        telemetry = {
          metrics = false;
          diagnostics = false;
        };

        theme = "Catppuccin Mocha";
        ui_font_size = 15;
        buffer_font_size = 13;

        autosave = "on_focus_change";
        auto_update = false;

        git.inline_blame = {
          enabled = true;
          delay_ms = 5000;
        };
        wrap_guides = [ 80 ];

        lsp = {
          rust-analyzer.binary.path = "${nixosConfig.lib.pkgs-unstable.rust-analyzer}/bin/rust-analyzer";
        };
      };

      extensions = [
        "catppuccin"
        "nix"
        "typst"
        "nu"
        "rust"
      ];
    };
  };

  options = with lib; {
    programs.zed-editor = {
      userSettings = mkOption {
        type = jsonFormat.type;
        default = { };
        description = ''
          Configuration written to Zed's {file}`settings.json`.
        '';
      };
      userKeymaps = mkOption {
        type = jsonFormat.type;
        default = { };
        description = ''
          Configuration written to Zed's {file}`keymap.json`.
        '';
      };
      extensions = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          A list of the extensions Zed should install on startup.
          Use the name of a repository in the [extension list](https://github.com/zed-industries/extensions/tree/main/extensions).
        '';
      };
    };
  };
}
