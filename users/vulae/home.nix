{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nvim/nixvim.nix
    ./kitty.nix
  ];

  home = {
    username = "vulae";
    homeDirectory = "/home/vulae";

    pointerCursor = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    packages = with pkgs; [
      hyfetch
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

  programs.firefox.enable = true;
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

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.11";
}
