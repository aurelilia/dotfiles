# Credit to: https://github.com/justinlime/dotfiles
# Adapted from there.
let
  custom = {
    primary_accent = "cba6f7";
    secondary_accent = "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "rgba(0,0,0,0)";
    background2 = "1e1e2e";
  };
in
{ pkgs, nixosConfig, ... }:
{
  home.packages = with pkgs; [
    playerctl
    pulseaudio
  ];

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      position = "bottom";
      layer = "top";
      height = 35;
      margin-top = 0;
      margin-bottom = 0;
      margin-left = 0;
      margin-right = 0;
      modules-left = [
        "custom/launcher"
        "custom/playerctl#backward"
        "custom/playerctl#play"
        "custom/playerctl#forward"
        "custom/playerlabel"
      ];
      modules-center = [ "sway/workspaces" ];
      modules-right =
        if nixosConfig.feline.power-management.enable then
          [
            "sway/window"
            "battery"
            "brightness"
            "pulseaudio"
            "network"
            "clock"
          ]
        else
          [
            "sway/window"
            "pulseaudio"
            "clock"
          ];

      clock = {
        format = " {:%a %d %b, %I:%M}";
        tooltip = "true";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt = " {:%d/%m}";
      };
      "sway/workspaces" = {
        format = "{name}";
        on-click = "activate";
        format-icons = {
          urgent = "";
          active = "";
          default = "";
          sort-by-number = true;
        };
      };
      "sway/window" = {
        format = "≋ {title} ≋";
        all-outputs = true;
      };
      "custom/playerctl#backward" = {
        format = "󰙣 ";
        on-click = "playerctl -p Feishin previous";
        on-scroll-up = "playerctl -p Feishin volume .05+";
        on-scroll-down = "playerctl -p Feishin volume .05-";
      };
      "custom/playerctl#play" = {
        format = "{icon}";
        return-type = "json";
        exec = "playerctl -p Feishin -a metadata --format '{\"text\": \"{{markup_escape(artist)}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
        on-click = "playerctl -p Feishin play-pause";
        on-scroll-up = "playerctl -p Feishin volume .05+";
        on-scroll-down = "playerctl -p Feishin volume .05-";
        format-icons = {
          Playing = "<span>󰏥 </span>";
          Paused = "<span> </span>";
          Stopped = "<span> </span>";
        };
      };
      "custom/playerctl#forward" = {
        format = "󰙡 ";
        on-click = "playerctl -p Feishin next";
        on-scroll-up = "playerctl -p Feishin volume .05+";
        on-scroll-down = "playerctl -p Feishin volume .05-";
      };
      "custom/playerlabel" = {
        format = "<span>󰎈 {} 󰎈</span>";
        return-type = "json";
        max-length = 80;
        exec = "playerctl -p Feishin -a metadata --format '{\"text\": \"{{markup_escape(artist)}} - {{markup_escape(title)}} [{{duration(position)}} / {{duration(mpris:length)}}]\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
        on-click = "";
      };
      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon}  {capacity}%";
        format-charging = "  {capacity}%";
        format-plugged = " {capacity}% ";
        format-alt = "{icon} {time}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };

      memory = {
        format = "󰍛 {}%";
        format-alt = "󰍛 {used}/{total} GiB";
        interval = 5;
      };
      cpu = {
        format = "󰻠 {usage}%";
        format-alt = "󰻠 {avg_frequency} GHz";
        interval = 5;
      };
      network = {
        format-wifi = " {signalStrength}%";
        format-ethernet = "󰈀 100% ";
        tooltip-format = "Connected to {essid}";
        format-linked = "{ifname} (No IP)";
        format-disconnected = "󰖪 0% ";
      };
      tray = {
        icon-size = 20;
        spacing = 8;
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
        format-icons = {
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
        };
        scroll-step = 1;
        on-click = "sh ~/.config/sway/scripts/audio-click.sh";
      };
      "custom/launcher" = {
        format = "";
        on-click = "ulauncher-toggle";
        tooltip = "false";
      };
    };
    style = ''
      * {
          border: none;
          border-radius: 0px;
          font-family: "Iosevka";
          font-size: 14px;
          min-height: 0;
      }

      window#waybar {
          background: ${custom.background};
      }

      #workspaces {
          background: #${custom.background2};
          margin: 5px 5px;
          padding: 8px 5px;
          border-radius: 16px;
          color: #${custom.primary_accent}
      }
      #workspaces button {
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: #cdd6f4;
          background: ${custom.background};
          transition: all 0.3s ease-in-out;
      }

      #workspaces button.visible {
          background-color: #f38ba8;
          color: #11111b;
          border-radius: 16px;
          min-width: 50px;
          background-size: 400% 400%;
          transition: all 0.3s ease-in-out;
      }

      #workspaces button:hover {
          background-color: #eba0ac;
          color: #11111b;
          border-radius: 16px;
          min-width: 50px;
          background-size: 400% 400%;
      }

      #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.forward{
          background: #${custom.background2};
          font-weight: bold;
          margin: 5px 0px;
      }
      #tray, #pulseaudio, #network, #battery{
          background: #${custom.background2};
          color: #${custom.tertiary_accent};
          border-radius: 24px 10px 24px 10px;
          padding: 0 20px;
          margin: 5px 0px;
          margin-left: 7px;
      }
      #clock {
          color: #${custom.tertiary_accent};
          background: #${custom.background2};
          border-radius: 40px 0px 0px 0px;
          padding: 0 10px 0 25px;
          margin-left: 7px;
      }
      #custom-launcher {
          color: #${custom.secondary_accent};
          background: #${custom.background2};
          border-radius: 0px 40px 0px 0px;
          margin: 0px;
          padding: 0px 35px 0px 15px;
          font-size: 28px;
      }

      #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.forward {
          background: #${custom.background2};
          font-size: 22px;
      }
      #custom-playerctl.backward:hover, #custom-playerctl.play:hover, #custom-playerctl.forward:hover{
          color: #${custom.tertiary_accent};
      }
      #custom-playerctl.backward {
          color: #${custom.primary_accent};
          border-radius: 10px 0px 0px 24px;
          padding-left: 16px;
          margin-left: 7px;
      }
      #custom-playerctl.play {
          color: #${custom.secondary_accent};
          padding: 0 5px;
      }
      #custom-playerctl.forward {
          color: #${custom.primary_accent};
          border-radius: 0px 24px 10px 0px;
          padding-right: 12px;
          margin-right: 7px
      }
      #custom-playerlabel {
          background: #${custom.background2};
          color: #${custom.tertiary_accent};
          padding: 0 20px;
          border-radius: 10px 24px 10px 24px;
          margin: 5px 0;
      }
      window#waybar #window {
          background: #${custom.background2};
          color: #${custom.tertiary_accent};
          padding: 0 20px;
          border-radius: 24px 10px 24px 10px;
          margin: 5px 0;
      }
    '';
  };
}
