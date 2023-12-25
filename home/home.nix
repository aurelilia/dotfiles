{ config, lib, pkgs, ... }: {
  imports = [
    ./modules/bat.nix
    ./modules/git.nix
    ./modules/lsd.nix
    ./modules/micro.nix
    ./modules/starship.nix
    ./modules/zsh.nix
  ];

  config = {
    home.stateVersion = "23.11";
    home.activation."diff" = ''
      ${pkgs.nvd}/bin/nvd --color=always diff "$oldGenPath" "$newGenPath"
      ${pkgs.colordiff}/bin/colordiff \
        --nobanner --fakeexitcode --color=always -ur -I '\/nix\/store' \
        -x "home-path" \
        -- "$oldGenPath" "$newGenPath"
    '';

    home.packages = with pkgs; [
      apprise
      colordiff
      fd
      htop
      neofetch
      nvd
      rsync
      sshfs
      less
      ncdu
    ];
  };
}
