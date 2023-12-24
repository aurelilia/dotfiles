{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfreePredicate = _: true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;

    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc-icons
      catppuccin.catppuccin-vsc

      ms-vscode.cpptools
      twxs.cmake
      xaver.clang-format

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

  programs.zsh.shellAliases = {
    code = "codium";
  };
}
