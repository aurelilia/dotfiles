{ nixosConfig, ... }:
{
  config = {
    programs.zed-editor = {
      enable = true;
      package = nixosConfig.lib.pkgs-unstable.zed-editor;
      userSettings = {
        base_keymap = "VSCode";
        telemetry = {
          metrics = false;
          diagnostics = false;
        };

        ui_font_size = 15;
        ui_font_family = "Noto Sans";
        buffer_font_size = 13;
        buffer_font_family = "FiraCode Nerd Font Mono";

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
}
