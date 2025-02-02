{
  programs.kitty = {
    # enable = true;
    shellIntegration.enableZshIntegration = true;
    themeFile = "Catppuccin-Mocha";
    settings = {
      notify_on_cmd_finish = "never";
      focus_follows_mouse = true;
      hide_window_decorations = true;

      background_opacity = "0.85"; # Docs say settings is string, boolean, or signed integer.
      background_blur = 8;
      
      tab_bar_margin_width = 8;
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_bar_align = "left";
      tab_bar_min_tabs = 2;
      tab_bar_edge = "bottom";
      tab_activity_symbol = "*";
      tab_title_template = "{index}{activity_symbol}: {title}";
      active_tab_foreground = "#000";
      active_tab_background = "#DDD";
      active_tab_font_style = "bold-italic";
      inactive_tab_foreground = "#FFF";
      inactive_tab_background = "#333";
      inactive_tab_font_style = "normal";
    };
  };
}
