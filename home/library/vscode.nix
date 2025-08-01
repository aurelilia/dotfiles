{
  nixosConfig,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vscode-extension-github-copilot"
      "rust-rover"
    ];
  programs.vscode = {
    enable = true;
    package = nixosConfig.lib.pkgs-unstable.vscodium.fhsWithPackages (ps: with ps; [ nil ]);

    extensions = with nixosConfig.lib.pkgs-unstable.vscode-extensions; [
      catppuccin.catppuccin-vsc-icons

      rust-lang.rust-analyzer
      tamasfe.even-better-toml

      streetsidesoftware.code-spell-checker
      yzhang.markdown-all-in-one

      bbenoist.nix # This one just has better syntax highlight, sorry nix-ide
      jnoortheen.nix-ide
      mkhl.direnv

      thenuprojectcontributors.vscode-nushell-lang
      myriad-dreamin.tinymist
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

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";

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

  feline.shellAliases.code = "codium";
}
