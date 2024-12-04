# https://github.com/nix-community/home-manager/pull/5455
{
  nixosConfig,
  ...
}: {
  config = {
    home.packages = [ nixosConfig.lib.pkgs-unstable.zed-editor ];
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
}
