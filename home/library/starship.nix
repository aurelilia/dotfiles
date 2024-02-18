{ ... }:
{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;

    settings = {
      format = "$directory$nix_shell$hostname$character";
      right_format = "$cmd_duration";
      add_newline = false;

      character = {
        success_symbol = "[λ](#b4befe) ›";
        error_symbol = "[λ](#f38ba8) ›";
      };

      directory = {
        format = "[]($style)[ ](bg:#24263a fg:#b4befe)[$path](bg:#24263a fg:#BBC3DF)[ ]($style)";
        style = "bg:none fg:#24263a";
        truncation_length = 1;
        truncate_to_repo = false;
        fish_style_pwd_dir_length = 1;
      };

      cmd_duration = {
        min_time = 100000;
        format = "[]($style)[in (bg:#24263a fg:#eba0ac bold)$duration](bg:#24263a fg:#BBC3DF)[ ]($style)";
        style = "bg:none fg:#24263a";
      };

      nix_shell.format = "❄️(bold blue) ";
      hostname.format = "[$hostname](bold red) ";
    };
  };
}
