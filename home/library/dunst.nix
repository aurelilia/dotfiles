{ pkgs, lib, ... }:
{
  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "red";
      };
    };

    settings = {
      global = {
        # https://dunst-project.org/documentation/#WAYLAND
        monitor = "DP-1";
        follow = "none";
        enable_posix_regex = true;
        width = 300;
        height = 300;
        notification_limit = 3;
        origin = "top-center";
        offset = "11x11";
        progress_bar = true;
        progress_bar_horizontal_alignment = "center";
        progress_bar_height = 15;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        progress_bar_frame_width = 3;
        progress_bar_corner_radius = 5;
        progress_bar_corners = "all";
        icon_corner_radius = 5;
        icon_corners = "all";
        indicate_hidden = true;
        separator_height = 3;
        padding = 6;
        text_icon_padding = 12;
        frame_width = 1;
        sort = "true";
        idle_threshold = 0;
        layer = "overlay";
        force_xwayland = false;
        font = "Noto Sans Regular 10";
        line_height = 3;
        format = "<b>%s</b>\n%b";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        sticky_history = true;
        history_length = 25;
        dmenu = "rofi";
        browser = "firefox";
        always_run_script = true;
        corner_radius = 6;
        corners = "all";
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_current";
        ignore_dbusclose = true;
        override_pause_level = 0;
        frame_color = lib.mkForce "#f5c2e7";
      };
      urgency_normal = {
        background = lib.mkForce "#1e1e2e";
        foreground = lib.mkForce "#f5c2e7";
        timeout = 10;
      };
    };
  };
}
