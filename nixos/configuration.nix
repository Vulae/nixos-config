{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # ZRAM, I need to download more ram smh :(
  zramSwap = {
    enable = true;
  };

  # Nvidia drivers stuff
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vulae = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input" # TEMP: This should probably not be set.
    ];
    shell = pkgs.zsh;
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    # Helps with package cache, or something. IDK I just copied this from somewhere.
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    niri
    wl-clipboard wayland-utils xwayland-satellite
  ];

  # Disable some default gnome apps
  environment.gnome.excludePackages = with pkgs; [
    baobab      # disk usage analyzer
    cheese      # photo booth
    eog         # image viewer
    epiphany    # web browser
    gedit       # text editor
    simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    evince      # document viewer
    file-roller # archive manager
    geary       # email client
    seahorse    # password manager

    # these should be self explanatory
    gnome-calculator gnome-calendar gnome-characters gnome-clocks gnome-contacts
    gnome-font-viewer # gnome-logs
    gnome-maps gnome-music gnome-photos # gnome-screenshot gnome-system-monitor
    gnome-weather gnome-disk-utility gnome-connections gnome-tour
  ];

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config = {
      niri.default = "gnome";
    };
  };

  services.displayManager.sessionPackages = [ pkgs.niri ];

  programs.git.enable = true;
  programs.zsh.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  hardware.steam-hardware.enable = true;

  # Create tmpfs for steam recordings (I have enough RAM, and don't want to utterly destroy my SSD)
  fileSystems."/home/vulae/.steam_recordings/video" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "size=4G"
      "mode=1777"
      # 'id' COMMAND OUT: uid=1000(vulae) gid=100(users) groups=100(users)
      "uid=1000"
      "gid=100"
    ];
  };
  system.activationScripts.createSteamRecordingsDir = {
    text = ''
      mkdir -p /home/vulae/.steam_recordings/video
      chmod -R 775 /home/vulae/.steam_recordings
      chown -R vulae:users /home/vulae/.steam_recordings
    '';
    deps = [];
  };

  programs.gamemode.enable = true;

  programs.anime-game-launcher.enable = false;
  programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = false;
  programs.honkers-launcher.enable = false;
  programs.wavey-launcher.enable = false;
  programs.sleepy-launcher.enable = false;
  
  # TEMP: Until https://github.com/ItsDeltin/Overwatch-Script-To-Workshop to work, this is the stupid workaround.
  # programs.nix-ld = {
  #   enable = true;
  # };

  security.pam.loginLimits = [
    # Disable coredumps
    {
      domain = "*";
      item = "core";
      type = "-";
      value = "0";
    }
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
