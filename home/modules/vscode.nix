{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfreePredicate = _: true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;

    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc-icons
      catppuccin.catppuccin-vsc

      rust-lang.rust-analyzer
      tamasfe.even-better-toml

      streetsidesoftware.code-spell-checker
      yzhang.markdown-all-in-one

      bbenoist.nix
      mkhl.direnv
    ];

    userSettings = {
      "workbench.iconTheme" = "catppuccin-mocha";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "files.exclude" = {
        "**/.classpath" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/.factorypath" = true;
      };

      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;

      "rust-analyzer.lens.enable" = false;
      "rust-analyzer.inlayHints.chainingHints" = false;
      "rust-analyzer.inlayHints.enable" = false;
      "rust-analyzer.inlayHints.parameterHints" = false;
      "rust-analyzer.inlayHints.typeHints" = false;

      "files.autoSave" = "onFocusChange";
      "editor.rulers" = [ 80 ];
      "editor.minimap.enabled" = true;
      "editor.fontFamily" = "'Fira Code Mono', 'Noto Sans Mono'";
      "editor.fontLigatures" = true;
      "cSpell.enabled" = false;

      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
    };
  };

  programs.zsh.shellAliases = { code = "codium"; };
  # Electron is currently broken
  # TODO: Remove once Electron supports Wayland properly
  # https://github.com/electron/electron/issues/39449
  #
  # Sway, for this reason, also sets scale to 1.0 on
  # switching to the third workspace, which I usually use VSC on
  # (Since running in XWayland with fractional scaling is very blurry)
  # home.sessionVariables.NIXOS_OZONE_WL = "1";
}
