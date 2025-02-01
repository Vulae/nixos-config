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
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "24.11";
}
