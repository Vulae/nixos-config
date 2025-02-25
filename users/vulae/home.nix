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

    packages = with pkgs; [
      ffmpeg

      pciutils # NOTE: Needed for neofetch to detect GPU
      wget
      bc # Command line calculator

      vesktop # Discord 

      # Minecraft
      (prismlauncher.override {
        jdks = [
          jdk17
          jdk21
          zulu17
          zulu21
          graalvm-ce
        ];
      })

      # Steam Proton
      protonup-qt
      protontricks

      # Image editor / utilities
      gimp
      imagemagick

      # Gnome customization
      gnomeExtensions.hide-top-bar
      gnomeExtensions.blur-my-shell
    ];

    pointerCursor = {
      gtk.enable = true;
      name = "Quintom_Ink";
      package = pkgs.quintom-cursor-theme;
      size = 28;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          hide-top-bar.extensionUuid
          blur-my-shell.extensionUuid
        ];
      };
      "org/gnome/desktop/interface" = {
        clock-format = "12h";
      };
      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
        speed = "0.4";
      };
      "org/gnome/desktop/input-sources" = {
        xkb-options = ["compose:ralt"];
      };
      # FIXME: When going into overview, fullscreen applications get resized with a 'fake' top bar, which is never visible.
      "org/gnome/shell/extensions/hidetopbar" = {
        mouse-sensitivity = false;
        animation-time-overview = 0;
        animation-time-autohide = 0;
        enable-intellihide = false;
      };
    };
  };

  home.file.".XCompose".source = ./.XCompose;

  home.file.".config/autostart/wallpaper.sh".source = ./wallpaper.sh;

  gtk = {
    enable = true;
    iconTheme = {
      name = "candy-icons";
      package = pkgs.candy-icons;
    };
    theme = {
      name = "Sweet-Dark";
      package = pkgs.sweet;
    };
    cursorTheme = {
      name = "Quintom_Ink";
      package = pkgs.quintom-cursor-theme;
      size = 28;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  home.sessionVariables.GTK_THEME = "Sweet-Dark";

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

  home.file.".config/vesktop/themes/vulae.theme.css".source = ./discord.theme.css;

  programs.fuzzel.enable = true;

  home.file.".config/niri/config.kdl".source = ./niri.kdl;

  programs.vscode = {
    enable = true;
    userSettings = {
      "window.titleBarStyle" = "custom";
      "editor.autoClosingBrackets" = "always";
      "editor.inlayHints.enabled" = "offUnlessPressed";
      "security.workspace.trust.enabled" = false;
      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;
      "editor.formatOnSave" = true;
      "editor.useTabStops" = false;
      "editor.quickSuggestions" = {
          "other" = "on";
          "comments" = "off";
          "strings" = "on";
      };
      "rust-analyzer.cargo.sysroot" = "discover";
      "rust-analyzer.check.command" = "clippy";
      "rust-analyzer.checkOnSave" = true;
      "terminal.integrated.defaultProfile.linux" = "zsh";
    };
    extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
    ];
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
