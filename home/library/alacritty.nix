{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "-l" ];
      };

      bell.duration = 0;
      colors.draw_bold_text_with_bright_colors = true;

      window = {
        decorations = "None";
        opacity = 0.7;
        padding = {
          x = 2;
          y = 2;
        };
      };

      font = {
        size = 12;
        normal.family = "Fira Code Nerd Font";
        bold.family = "DejaVu Sans Mono";
      };

      cursor = {
        style = "Beam";
        unfocused_hollow = false;
      };

      live_config_reload = false;

      mouse = {
        bindings = [
          {
            action = "PasteSelection";
            mouse = "Middle";
          }
        ];
        hide_when_typing = false;
      };

      keyboard.bindings = [
        {
          action = "Paste";
          key = "Paste";
        }
        {
          action = "Copy";
          key = "Copy";
        }
        {
          action = "ClearLogNotice";
          key = "L";
          mods = "Control";
        }
        {
          chars = "";
          key = "L";
          mods = "Control";
        }
        {
          chars = "OH";
          key = "Home";
          mode = "AppCursor";
        }
        {
          chars = "[H";
          key = "Home";
          mode = "~AppCursor";
        }
        {
          chars = "OF";
          key = "End";
          mode = "AppCursor";
        }
        {
          chars = "[F";
          key = "End";
          mode = "~AppCursor";
        }
        {
          action = "ScrollPageUp";
          key = "PageUp";
          mode = "~Alt";
          mods = "Shift";
        }
        {
          chars = "[5;2~";
          key = "PageUp";
          mode = "Alt";
          mods = "Shift";
        }
        {
          chars = "[5;5~";
          key = "PageUp";
          mods = "Control";
        }
        {
          chars = "[5~";
          key = "PageUp";
        }
        {
          action = "ScrollPageDown";
          key = "PageDown";
          mode = "~Alt";
          mods = "Shift";
        }
        {
          chars = "[6;2~";
          key = "PageDown";
          mode = "Alt";
          mods = "Shift";
        }
        {
          chars = "[6;5~";
          key = "PageDown";
          mods = "Control";
        }
        {
          chars = "[6~";
          key = "PageDown";
        }
        {
          chars = "[Z";
          key = "Tab";
          mods = "Shift";
        }
        {
          chars = "";
          key = "Back";
        }
        {
          chars = "";
          key = "Back";
          mods = "Alt";
        }
        {
          chars = "[2~";
          key = "Insert";
        }
        {
          chars = "[3~";
          key = "Delete";
        }
        {
          chars = "[1;2D";
          key = "Left";
          mods = "Shift";
        }
        {
          chars = "[1;5D";
          key = "Left";
          mods = "Control";
        }
        {
          chars = "[1;3D";
          key = "Left";
          mods = "Alt";
        }
        {
          chars = "[D";
          key = "Left";
          mode = "~AppCursor";
        }
        {
          chars = "OD";
          key = "Left";
          mode = "AppCursor";
        }
        {
          chars = "[1;2C";
          key = "Right";
          mods = "Shift";
        }
        {
          chars = "[1;5C";
          key = "Right";
          mods = "Control";
        }
        {
          chars = "[1;3C";
          key = "Right";
          mods = "Alt";
        }
        {
          chars = "[C";
          key = "Right";
          mode = "~AppCursor";
        }
        {
          chars = "OC";
          key = "Right";
          mode = "AppCursor";
        }
        {
          chars = "[1;2A";
          key = "Up";
          mods = "Shift";
        }
        {
          chars = "[1;5A";
          key = "Up";
          mods = "Control";
        }
        {
          chars = "[1;3A";
          key = "Up";
          mods = "Alt";
        }
        {
          chars = "[A";
          key = "Up";
          mode = "~AppCursor";
        }
        {
          chars = "OA";
          key = "Up";
          mode = "AppCursor";
        }
        {
          chars = "[1;2B";
          key = "Down";
          mods = "Shift";
        }
        {
          chars = "[1;5B";
          key = "Down";
          mods = "Control";
        }
        {
          chars = "[1;3B";
          key = "Down";
          mods = "Alt";
        }
        {
          chars = "[B";
          key = "Down";
          mode = "~AppCursor";
        }
        {
          chars = "OB";
          key = "Down";
          mode = "AppCursor";
        }
        {
          chars = "OP";
          key = "F1";
        }
        {
          chars = "OQ";
          key = "F2";
        }
        {
          chars = "OR";
          key = "F3";
        }
        {
          chars = "OS";
          key = "F4";
        }
        {
          chars = "[15~";
          key = "F5";
        }
        {
          chars = "[17~";
          key = "F6";
        }
        {
          chars = "[18~";
          key = "F7";
        }
        {
          chars = "[19~";
          key = "F8";
        }
        {
          chars = "[20~";
          key = "F9";
        }
        {
          chars = "[21~";
          key = "F10";
        }
        {
          chars = "[23~";
          key = "F11";
        }
        {
          chars = "[24~";
          key = "F12";
        }
        {
          chars = "[1;2P";
          key = "F1";
          mods = "Shift";
        }
        {
          chars = "[1;2Q";
          key = "F2";
          mods = "Shift";
        }
        {
          chars = "[1;2R";
          key = "F3";
          mods = "Shift";
        }
        {
          chars = "[1;2S";
          key = "F4";
          mods = "Shift";
        }
        {
          chars = "[15;2~";
          key = "F5";
          mods = "Shift";
        }
        {
          chars = "[17;2~";
          key = "F6";
          mods = "Shift";
        }
        {
          chars = "[18;2~";
          key = "F7";
          mods = "Shift";
        }
        {
          chars = "[19;2~";
          key = "F8";
          mods = "Shift";
        }
        {
          chars = "[20;2~";
          key = "F9";
          mods = "Shift";
        }
        {
          chars = "[21;2~";
          key = "F10";
          mods = "Shift";
        }
        {
          chars = "[23;2~";
          key = "F11";
          mods = "Shift";
        }
        {
          chars = "[24;2~";
          key = "F12";
          mods = "Shift";
        }
        {
          chars = "[1;5P";
          key = "F1";
          mods = "Control";
        }
        {
          chars = "[1;5Q";
          key = "F2";
          mods = "Control";
        }
        {
          chars = "[1;5R";
          key = "F3";
          mods = "Control";
        }
        {
          chars = "[1;5S";
          key = "F4";
          mods = "Control";
        }
        {
          chars = "[15;5~";
          key = "F5";
          mods = "Control";
        }
        {
          chars = "[17;5~";
          key = "F6";
          mods = "Control";
        }
        {
          chars = "[18;5~";
          key = "F7";
          mods = "Control";
        }
        {
          chars = "[19;5~";
          key = "F8";
          mods = "Control";
        }
        {
          chars = "[20;5~";
          key = "F9";
          mods = "Control";
        }
        {
          chars = "[21;5~";
          key = "F10";
          mods = "Control";
        }
        {
          chars = "[23;5~";
          key = "F11";
          mods = "Control";
        }
        {
          chars = "[24;5~";
          key = "F12";
          mods = "Control";
        }
        {
          chars = "[1;6P";
          key = "F1";
          mods = "Alt";
        }
        {
          chars = "[1;6Q";
          key = "F2";
          mods = "Alt";
        }
        {
          chars = "[1;6R";
          key = "F3";
          mods = "Alt";
        }
        {
          chars = "[1;6S";
          key = "F4";
          mods = "Alt";
        }
        {
          chars = "[15;6~";
          key = "F5";
          mods = "Alt";
        }
        {
          chars = "[17;6~";
          key = "F6";
          mods = "Alt";
        }
        {
          chars = "[18;6~";
          key = "F7";
          mods = "Alt";
        }
        {
          chars = "[19;6~";
          key = "F8";
          mods = "Alt";
        }
        {
          chars = "[20;6~";
          key = "F9";
          mods = "Alt";
        }
        {
          chars = "[21;6~";
          key = "F10";
          mods = "Alt";
        }
        {
          chars = "[23;6~";
          key = "F11";
          mods = "Alt";
        }
        {
          chars = "[24;6~";
          key = "F12";
          mods = "Alt";
        }
        {
          chars = "[1;3P";
          key = "F1";
          mods = "Super";
        }
        {
          chars = "[1;3Q";
          key = "F2";
          mods = "Super";
        }
        {
          chars = "[1;3R";
          key = "F3";
          mods = "Super";
        }
        {
          chars = "[1;3S";
          key = "F4";
          mods = "Super";
        }
        {
          chars = "[15;3~";
          key = "F5";
          mods = "Super";
        }
        {
          chars = "[17;3~";
          key = "F6";
          mods = "Super";
        }
        {
          chars = "[18;3~";
          key = "F7";
          mods = "Super";
        }
        {
          chars = "[19;3~";
          key = "F8";
          mods = "Super";
        }
        {
          chars = "[20;3~";
          key = "F9";
          mods = "Super";
        }
        {
          chars = "[21;3~";
          key = "F10";
          mods = "Super";
        }
        {
          chars = "[23;3~";
          key = "F11";
          mods = "Super";
        }
        {
          chars = "[24;3~";
          key = "F12";
          mods = "Super";
        }
        {
          chars = "\n";
          key = "NumpadEnter";
        }
      ];
    };
  };
}
