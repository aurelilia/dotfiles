# https://jnsgr.uk/2024/02/packaging-scrutiny-for-nixos
# Thank you!
{
  lib,
  pkgs,
  name,
  config,
  ...
}:
let
  collector = pkgs.buildGoModule rec {
    repo = pkgs.fetchFromGitHub {
      owner = "AnalogJ";
      repo = "scrutiny";
      rev = "v0.7.2";
      sha256 = "sha256-UYKi+WTsasUaE6irzMAHr66k7wXyec8FXc8AWjEk0qs=";
    };

    vendorHash = "sha256-SiQw6pq0Fyy8Ia39S/Vgp9Mlfog2drtVn43g+GXiQuI=";
    name = "scrutiny";
    pname = "${name}-collector";
    src = repo;

    buildInputs = with pkgs; [ makeWrapper ];

    CGO_ENABLED = 0;
    buildPhase = ''
      runHook preBuild
      go build \
        -o scrutiny-collector-metrics \
        -ldflags="-extldflags=-static" \
        -tags "static netgo" \
        ./collector/cmd/collector-metrics
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp scrutiny-collector-metrics $out/bin/scrutiny-collector-metrics

      wrapProgram $out/bin/scrutiny-collector-metrics \
        --prefix PATH : ${lib.makeBinPath [ pkgs.smartmontools ]}
    '';

    meta = {
      description = "Hard disk metrics collector for Scrutiny.";
      homepage = "https://github.com/AnalogJ/scrutiny";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ jnsgruk ];
    };
  };
in
{
  config = lib.mkIf config.elia.smartd.enable {
    services.smartd = {
      enable = true;
      extraOptions = [
        "-A /var/log/smartd/"
        "--interval=3600"
      ];
    };

    systemd.services.scrutiny-collector = {
      description = "Scrutiny Collector Service";
      environment = {
        COLLECTOR_API_ENDPOINT = "http://haze:53042";
        COLLECTOR_HOST_ID = "${name}";
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${collector}/bin/scrutiny-collector-metrics run";
      };
    };

    systemd.timers.scrutiny-collector = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "hourly";
        Unit = "scrutiny-collector.service";
      };
    };
  };
  options.elia.smartd.enable = lib.mkOption {
    type = lib.types.bool;
    description = "Enable smartd monitoring with Scrutiny.";
    default = true;
  };
}
