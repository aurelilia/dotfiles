{ lib, config, ... }: {
  options = {
    kit.archetype = lib.mkOption {
      type = lib.types.enum [
        "server"
        "deskop"
        "mobile"
        "generic"
      ];
      default = "generic";
      description = "What archetype to use for base configuration.";
    };
  };

  config = if (config.kit.archetype == "server") then {

  } else if (config.kit.archetype == "desktop") then {

  } else if (config.kit.archetype == "mobile") then {
    environment.systemPackages = [ pkgs.brightnessctl ];

    kit = {
      power-management = true;
      wireless = true;
    };
  } else {};
}
