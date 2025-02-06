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
      pciutils # NOTE: Needed for neofetch to detect GPU
      ffmpeg
      wget
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

  # TODO: Figure out how to enable compose key through this config.
  home.file.".XCompose".source = ./.XCompose;

  programs.firefox = {
    enable = true;
    profiles.default = {
      extraConfig = builtins.readFile ./firefox.js;
      # TODO: Search engine icons
      search.engines = {
        "Google".metaData.hideOneOffButton = true;
        "DuckDuckGo".metaData.hideOneOffButton = true;
        "Bing".metaData.hideOneOffButton = true;
        "Wikipedia (en)".metaData.alias = "!w";
        "GitHub" = {
          definedAliases = [ "!gh" ];
          urls = [{
            template = "https://github.com/search?q={searchTerms}&ref=opensearch";
          }];
        };
        "YouTube" = {
          definedAliases = [ "!yt" ];
          urls = [{
            template = "https://www.youtube.com/results?search_query={searchTerms}&page={startPage}&utm_source=opensearch";
          }];
        };
        # NOTE: Non-official
        "Twitch" = {
          definedAliases = [ "!tw" ];
          urls = [{
            template = "https://www.twitch.tv/search?term={searchTerms}";
          }];
        };
        # NOTE: Non-official
        "Reddit" = {
          definedAliases = [ "!r" ];
          urls = [{
            template = "https://www.reddit.com/search/?q={searchTerms}";
          }];
        };
        "Docs.rs" = {
          definedAliases = [ "!rd" ];
          urls = [{
            template = "https://docs.rs/releases/search?query={searchTerms}";
          }];
        };
        "NixOS packages" = {
          definedAliases = [ "!n" ];
          urls = [{
            template = "https://search.nixos.org/packages?query={searchTerms}";
          }];
        };
        "NixOS Home Manager Options" = {
          definedAliases = [ "!nhm" ];
          urls = [{
            template = "https://home-manager-options.extranix.com/?query={searchTerms}";
          }];
        };
        "My Anime List" = {
          definedAliases = [ "!mal" ];
          urls = [{
            template = "https://myanimelist.net/anime.php?q={searchTerms}";
          }];
        };
        # NOTE: Non-official
        "Crunchyroll" = {
          definedAliases = [ "!cr" ];
          urls = [{
            template = "https://www.crunchyroll.com/search?q={searchTerms}";
          }];
        };
      };
    };
  };
  # Firefox automatically overrides this file, so we have to just ignore the collision.
  home.file.".mozilla/firefox/default/search.json.mozlz4".force = lib.mkForce true;

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
    font = {
      package = pkgs.cascadia-code;
      name = "CaskaydiaCoveNF-Regular";
    };
    settings = {
      font_features = "CaskaydiaCoveNF-Regular -liga";

      notify_on_cmd_finish = "never";
      focus_follows_mouse = true;
      hide_window_decorations = true;

      background_opacity = "0.85";
      background_blur = 8;

      tab_bar_min_tabs = 2;
      tab_bar_background = "#1e1e2e";
      tab_bar_edge = "bottom";
      tab_bar_align = "left";
      tab_bar_margin_width = 8;
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_activity_symbol = "*";
      tab_title_template = "{index}{activity_symbol}: {title}";
      active_tab_foreground = "#11111b";
      active_tab_background = "#cba6f7";
      active_tab_font_style = "bold-italic";
      inactive_tab_foreground = "#74c7ec";
      inactive_tab_background = "#11111b";
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

  programs.obs-studio.enable = true;

  home.file.".config/vesktop/themes/vulae.theme.css".source = ./vulae.theme.css;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
