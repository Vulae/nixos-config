{
  inputs,
  lib,
  config,
  pkgs,
  my-keyboard,
  ...
}:
let
  my-keyboard-pkg = my-keyboard.packages.${pkgs.system}.default;
in
{
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
      ffmpeg-full

      pciutils # Needed for neofetch to detect GPU
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
          semeru-bin-17
          semeru-bin # 21
        ];
      })

      # Steam Proton
      protonup-qt
      protontricks

      bottles

      # Image editor / utilities
      gimp
      aseprite
      imagemagick

      vlc

      # Gnome customization
      gnomeExtensions.hide-top-bar
      gnomeExtensions.blur-my-shell
      
      # Rust development tools
      cargo-info
      rusty-man
      cargo-show-asm

      nix-init
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
        xkb-options = ["compose:ralt" "caps:backspace"];
      };
      # FIXME: When going into overview, fullscreen applications get resized with a 'fake' top bar, which is never visible.
      "org/gnome/shell/extensions/hidetopbar" = {
        mouse-sensitivity = false;
        animation-time-overview = 0;
        animation-time-autohide = 0;
        enable-intellihide = false;
      };
      "org/gnome/mutter" = {
        # FIXME: This doesn't seem to set correctly.
        check-alive-timeout = 60000;
      };
    };
  };

  home.file.".XCompose".source = ./.XCompose;

  systemd.user.services.my-keyboard = {
    Unit = {
      Description = "Keyboard lighting effects";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe my-keyboard-pkg}";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  # home.file.".config/autostart/wallpaper.sh".source = ./wallpaper.sh;

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
        google.metaData.hidden = true;
        ddg.metaData.hidden = true;
        bing.metaData.hidden = true;
        ebay.metaData.hidden = true;
        # FIXME: Doesn't disable @amazon search??????
        amazon.metaData.hidden = true;
        wikipedia.metaData.alias = "!w";
        github = {
          definedAliases = [ "!gh" ];
          urls = [{
            template = "https://github.com/search?q={searchTerms}&ref=opensearch";
          }];
          iconMapObj."32" = "https://github.com/favicon.ico";
        };
        youtube = {
          definedAliases = [ "!yt" ];
          urls = [{
            template = "https://www.youtube.com/results?search_query={searchTerms}&page={startPage}&utm_source=opensearch";
          }];
          iconMapObj."16" = "https://www.youtube.com/favicon.ico";
        };
        twitch = {
          definedAliases = [ "!tw" ];
          urls = [{
            template = "https://www.twitch.tv/search?term={searchTerms}";
          }];
          iconMapObj."32" = "https://www.twitch.tv/favicon.ico";
        };
        reddit = {
          definedAliases = [ "!r" ];
          urls = [{
            template = "https://www.reddit.com/search/?q={searchTerms}";
          }];
          iconMapObj."32" = "https://reddit.com/favicon.ico";
        };
        rust-docs = {
          definedAliases = [ "!rd" ];
          urls = [{
            template = "https://doc.rust-lang.org/std/index.html?search={searchTerms}";
          }];
          iconMapObj."196" = "https://doc.rust-lang.org/favicon.ico";
        };
        rust-crates-docs = {
          definedAliases = [ "!rc" ];
          urls = [{
            template = "https://docs.rs/releases/search?query={searchTerms}";
          }];
          iconMapObj."32" = "https://docs.rs/-/static/favicon.ico";
        };
        nix-packages = {
          definedAliases = [ "!n" ];
          urls = [{
            template = "https://search.nixos.org/packages?query={searchTerms}";
          }];
          iconMapObj."16" = "https://search.nixos.org/favicon.png";
        };
        nix-home-manager = {
          definedAliases = [ "!nhm" ];
          urls = [{
            template = "https://home-manager-options.extranix.com/?query={searchTerms}";
          }];
          iconMapObj."180" = "https://home-manager-options.extranix.com/images/favicon.png";
        };
        my-anime-list = {
          definedAliases = [ "!mal" ];
          urls = [{
            template = "https://myanimelist.net/anime.php?q={searchTerms}";
          }];
          iconMapObj."48" = "https://myanimelist.net/favicon.ico";
        };
        crunchyroll = {
          definedAliases = [ "!cr" ];
          urls = [{
            template = "https://www.crunchyroll.com/search?q={searchTerms}";
          }];
          iconMapObj."16" = "https://www.crunchyroll.com/build/assets/img/favicons/favicon-v2-16x16.png";
        };
        minecraft-wiki = {
          definedAliases = [ "!mw" ];
          urls = [{
            template = "https://minecraft.wiki/w/Special:Search?search={searchTerms}";
          }];
          iconMapObj."32" = "https://minecraft.wiki/favicon.ico";
        };
        modrinth = {
          definedAliases = [ "!mm" ];
          urls = [{
            template = "https://modrinth.com/mods?q={searchTerms}";
          }];
          iconMapObj."64" = "https://modrinth.com/favicon.ico";
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
    enable = true;
    package = pkgs.btop-cuda;
    settings = {
      color_theme = "kyli0x";
      theme_background = false;
      vim_keys = true;
      update_ms = 500;
      proc_per_core = true;
      proc_sorting = "memory";
      shown_boxes = "cpu gpu0 mem net proc";
      cpu_single_graph = true;
      gpu_mirror_graph = false;
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

  home.file.".config/vesktop/themes/CapnKitten.BetterDiscord.Material-Discord.theme.css".source = builtins.fetchurl {
    url = "https://raw.githubusercontent.com/CapnKitten/BetterDiscord/7e4a3bdc1f4f4906e4eef02d6fd7e26f0ae0bd10/Themes/Material-Discord/css/source.css";
    sha256 = "cd300438136d763660a916020ec50037c6bdc6073b8e48dd453571379455c89f";
  };

  programs.fuzzel.enable = true;

  home.file.".config/niri/config.kdl".source = ./niri.kdl;

  programs.vscode = {
    enable = true;
    profiles.default = {
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      userSettings = {
        "window.titleBarStyle" = "custom";
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "security.workspace.trust.enabled" = false;
        "explorer.confirmDragAndDrop" = false;
        "explorer.confirmDelete" = false;
        "editor.stickyScroll.enabled" = false;
        "editor.autoClosingBrackets" = "always";
        "editor.inlayHints.enabled" = "offUnlessPressed";
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
        "svelte.enable-ts-plugin" = true;
        "svelte.plugin.svelte.runesLegacyModeCodeLens.enable" = false;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "prettier.configPath" = ".prettierrc";
        "tailwindCSS.includeLanguages" = {
          "sass" = "css";
        };
        "ostw.deltintegerPath" = "/home/vulae/.config/Code/User/globalStorage/deltin.overwatch-script-to-workshop/Server/bin/linux-x64/Deltinteger";
      };
      extensions = with pkgs.vscode-extensions; [
        rust-lang.rust-analyzer
        svelte.svelte-vscode
        bradlc.vscode-tailwindcss
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        ecmel.vscode-html-css
        ms-dotnettools.csharp
        ms-dotnettools.csdevkit
        jnoortheen.nix-ide
        github.vscode-pull-request-github
        github.vscode-github-actions
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "overwatch-script-to-workshop";
          publisher = "deltin";
          version = "3.12.2";
          hash = "sha256-Ogkp9mlSLf5sFD2Lo4xDeRDja2Jp+sFnt0v98N62vR4=";
        }
      ];
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "catppuccin"
      "catppuccin-icons"
      # "snippets"
      "codebook" # Spellchecker
      "toml"
      "basher" # Bash language server
      "assembly"
      "html"
      "html-snippets"
      "svelte"
      "svelte-snippets"
      "css-modules-kit"
      "scss"
      "typescript-snippets"
    ];
    extraPackages = (with pkgs; [
      nixd
      nil
    ]);
    userSettings = {
      agent.enabled = false;
      theme = "Catppuccin Mocha";
      vim_mode = true;
      relative_line_numbers = true;
      git.inline_blame.enabled = false;
      format_on_save = "on";
    };
  };

  programs.mangohud = {
    enable = true;
    settings = {
      wine = true;
      winesync = true;

      gamemode = true;

      core_load = true;
      cpu_mhz = true;
      cpu_power = true;
      cpu_temp = true;

      gpu_power = true;
      gpu_temp = true;
      gpu_core_clock = true;
      vram = true;

      resolution = true;
      frametime = true;

      procmem = true;
      ram = true;

      io_read = true;
      io_write = true;

      # Hide by default, enable again by Shift_R+F12
      no_display = true;
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.05";
}
