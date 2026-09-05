{ ... }:
let
  root = "/persist/data/caddy/srv";
in
{
  # Static public pages are defined here.
  feline.caddy.routes = {
    "elia.garden".redir = "https://catin.eu";
    "branding.catin.eu".root = ../../../branding;

    "tessa.dog" = {
      root = "${root}/tessa";
      no-robots = false;
    };

    "catin.eu".root = "${root}/html";
    "elentari.eu".root = "${root}/elentari";

    # Google telemetry workaround for some networks
    "http://connectivitycheck.gstatic.com" = {
      extra = "respond /generate_204 204";
      configureDns = false;
      monitoringEnable = false;
    };
  };
}
