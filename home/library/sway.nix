{
  nixosConfig,
  config,
  pkgs,
  lib,
  ...
}:
{
  # Sway itself. Package is managed by NixOS
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    # Checks fail due to SwayFX options
    # Setting package to SwayFX fails to due missing GLES context...
    checkConfig = false;

    config = lib.mkMerge [
      nixosConfig.feline.gui.extraSway
      rec {
        modifier = "Mod4";

        # Behavior
        focus = {
          followMouse = "always";
          wrapping = "workspace";
        };
        workspaceAutoBackAndForth = true;

        # Assigns
        assigns = {
          "10" = [ { app_id = "thunderbird"; } ];
        };

        # Appearance
        fonts = {
          names = [ "DejaVu Sans" ];
          size = 9.0;
        };
        gaps = {
          inner = 3;
          outer = 2;
        };
        colors.focused = {
          background = "#f38ba8";
          border = "#f38ba8";
          childBorder = "#f38ba8";
          indicator = "#ffa6f7ff";
          text = "#cdd6f4";
        };
        floating.border = 2;
        window = {
          border = 1;
          titlebar = false;
          commands = [
            {
              command = "border none";
              criteria.app_id = "ulauncher";
            }
            {
              command = "inhibit_idle fullscreen";
              criteria.app_id = ".*";
            }
            {
              command = "inhibit_idle fullscreen";
              criteria.class = ".*";
            }
          ];
        };

        # Keymap
        input."*" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl";
        };

        # Keybinds
        modes.resize = {
          Left = "resize shrink width 10px";
          Down = "resize grow height 10px";
          Up = "resize shrink height 10px";
          Right = "resize grow width 10px";
          Return = "mode default";
          Escape = "mode default";
        };

        keybindings = {
          # Start a terminal
          "${modifier}+Return" = "exec alacritty";
          # Kill focused window
          "Mod1+4" = "kill";
          # Start launcher
          "${modifier}+t" = "exec rofi -show-icons -show drun";
          "${modifier}+shift+period" = "exec rofimoji -r emoji";
          # Dunst history
          "${modifier}+grave" = "exec dunstctl history-pop";
          # Screen locker
          "${modifier}+l" = "exec swaylock";
          # Screenshots
          "${modifier}+q" = "exec ~/.config/sway/scripts/screenshot.sh";
          "${modifier}+Shift+q" = "exec ~/.config/sway/scripts/screenshot-delay.sh";
          "${modifier}+Control+q" = "exec rofi-screenshot";
          # Pick a colour
          "${modifier}+p" = "exec ~/.config/sway/scripts/picker.sh";

          # Moving around
          # Move your focus around
          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          # Move the focused window with the same, but add Shift
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          # Workspaces
          # Switch to workspace
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 10";
          # Move focused container to workspace
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          # hoho haha
          "Control+Mod1+Mod4+Shift+E" = "exec firefox https://e621.net";

          # Layout stuff
          # You can "split" the current object of your focus with
          # $mod+b or $mod+v, for horizontal and vertical splits
          # respectively.
          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          # Resize mode
          "${modifier}+r" = "mode resize";

          # Switch the current container between different layout styles
          "${modifier}+n" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          # Make the current focus fullscreen
          "${modifier}+f" = "fullscreen";

          # Toggle the current focus between tiling and floating mode
          "${modifier}+Shift+space" = "floating toggle";

          # Swap focus between the tiling area and the floating area
          "${modifier}+space" = "focus mode_toggle";

          # Move focus to the parent container
          "${modifier}+a" = "focus parent";

          # Change scaling
          "${modifier}+x" = "output DP-3 scale 1.5";
          "${modifier}+c" = "output DP-3 scale 1";

          # Move the currently focused window to the scratchpad
          "${modifier}+Shift+minus" = "move scratchpad";
          # Show the next scratchpad window or hide the focused scratchpad window.
          # If there are multiple scratchpad windows, this command cycles through them.
          "${modifier}+minus" = "scratchpad show";
        };

        bars = [ ];
        startup = [ { command = "~/.config/sway/scripts/autostart.sh"; } ];
      }
    ];

    # SwayFX
    extraConfig = ''
      corner_radius 5
      tiling_drag enable

      # Window background blur
      blur on
      blur_xray on
      blur_passes 1
      blur_radius 7

      # Shadows
      shadows on
      shadows_on_csd off
      shadow_blur_radius 7
      shadow_color #1a1a1aee

      # Disable swaybg
      swaybg_command -

      # Tablet mode on bengal
      bindswitch tablet:on "output eDP-1 scale 1.5"
      bindswitch tablet:off "output eDP-1 scale 1.25"
    '';
  };
  xdg.configFile."sway/scripts".source = ../files/sway-scripts;

  # Swaylock
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = "200";
      indicator-thickness = "20";
      effect-blur = "8x5";
      effect-vignette = "0.5:0.5";
      effect-greyscale = true;
      grace = "0";
      fade-in = "0.2";
    };
  };

  # Swayidle
  services.swayidle =
    let
      lock = "'${config.programs.swaylock.package}/bin/swaylock'";
    in
    {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = lock;
        }
        {
          event = "lock";
          command = lock;
        }
      ];
      timeouts =
        [
          {
            timeout = 300;
            command = lock;
          }
          {
            timeout = 360;
            command = "'${pkgs.swayfx}/bin/swaymsg output * power off'";
            resumeCommand = "'${pkgs.swayfx}/bin/swaymsg output * power on'";
          }
        ]
        ++ lib.optional (nixosConfig.feline.gui.autoSuspend) {
          timeout = 600;
          command = "'${pkgs.systemd}/bin/systemctl suspend-then-hibernate'";
        };
    };
  systemd.user.services.swayidle.Service.Environment = [ "WAYLAND_DISPLAY=wayland-1" ];

  # Misc services
  # Ulauncher tries to open themes RW (?!?!) which obviously does not work
  # with the store, so we copy it's files directly out of this repo.
  # https://github.com/nix-community/home-manager/issues/257
  home.activation.linkUlauncher = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    rm -rf $HOME/.config/ulauncher || true
    cp -r ${../files/ulauncher} $HOME/.config/ulauncher
    chmod 755 -R $HOME/.config/ulauncher
  '';

  # Session variables
  systemd.user.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    _JAVA_AWT_WM_NONREPARENTING = 1;

    inherit (config.home.sessionVariables) XCURSOR_THEME XCURSOR_SIZE XCURSOR_PATH;
    WAYLAND_DISPLAY = "wayland-1";
  };

  # Packages
  home.packages = with pkgs; [
    autotiling-rs
    grim
    jq
    inetutils
    slurp
    wl-clipboard
    ydotool
    ripgrep
    libnotify
    nixosConfig.lib.pkgs-oldstable.swww
    alsa-utils
    catppuccin-cursors.mochaRed
  ];
}
