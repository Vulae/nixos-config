{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [];
  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
    };
  };
  home = {
    username = "vulae";
    homeDirectory = "/home/vulae";
    pointerCursor = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 32;
      gtk.enable = true;
    };
    packages = with pkgs; [
      kitty
      neovim
      btop
      hyfetch
      vesktop
      prismlauncher
      jdk # FIXME: Get jdk17 to work without conflicting with jdk
      gnomeExtensions.just-perfection
      cargo rustc rust-analyzer
      clang-tools openssl pkg-config
    ];
  };
  programs = {
    firefox.enable = true;
  };
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.11";
}
