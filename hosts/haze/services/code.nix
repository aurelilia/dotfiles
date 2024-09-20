{ pkgs, ... }: {
  services.code-server = {
    enable = true;
    disableTelemetry = true;
    host = "0.0.0.0";
    hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$ZHJqaG5lYmpudmJuem9ndA$3GbFWpZ+IUT+Iu8LVKNphEPqyqf1+rlybnmwLweNDvY";

    package = pkgs.vscode-with-extensions.override {
      vscode = pkgs.code-server;
      vscodeExtensions = with pkgs.vscode-extensions; [];
    };

    userDataDir = "/media/personal/code-server/.userdata";
    extensionsDir = "/media/personal/code-server/.extensions";
  };

  systemd.services.code-server.serviceConfig = {
    TemporaryFileSystem = "/";
    BindPaths = [ "/home/code-server" "/media/personal/code-server" ];
    BindReadOnlyPaths = "/nix/";    
  };

  networking.firewall.allowedTCPPorts = [ 4444 ];
}
