{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nvim/nixvim.nix
  ];

  home = {
    username = "vulae";
    homeDirectory = "/home/vulae";

    sessionVariables = {
      MANPAGER = "nvim +Man!";
    };

    pointerCursor = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    packages = with pkgs; [
      ffmpeg
      vesktop
      (prismlauncher.override {
        jdks = [
          jdk17
          jdk21
          zulu17
          zulu21
          graalvm-ce
        ];
      })
      gnomeExtensions.just-perfection
    ];
  };

  programs.firefox = {
    enable = true;
    profiles.vulae = {
      extraConfig = builtins.readFile ./firefox.js;
    };
  };

  programs.git = {
    enable = true;
    userName = "Vulae";
    userEmail = "vulae.f@gmail.com";
    extraConfig = {
      core = {
        editor = "nvim";
        pager = "nvim +Man!";
      };
    };
  };

  programs.gh.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "man" "rust" "gh" ];
    };
    shellAliases = {
      neofetch = "hyfetch";
    };
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    themeFile = "Catppuccin-Mocha";
    settings = {
      notify_on_cmd_finish = "never";
      focus_follows_mouse = true;
      hide_window_decorations = true;

      background_opacity = "0.85";
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

  programs.btop = {
    # FIXME: Doesn't show GPU
    enable = true;
    settings = {
      color_theme = "kyli0x";
      theme_background = false;
      vim_keys = true;
      update_ms = 500;
      proc_per_core = true;
      proc_sorting = "memory";
    };
  };

  home.file.".config/neofetch/config.conf".source = ./neofetch.conf;
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      lightness = 0.65;
      color_align = {
          mode = "horizontal";
      };
      backend = "neofetch";
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
