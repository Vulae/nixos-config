{
  description = "Vulae NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blender = {
      url = "github:edolstra/nix-warez/master?dir=blender";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pandora-launcher = {
      url = "github:Vulae/PandoraLauncher-nix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-keyboard = {
      url = "github:Vulae/my-keyboard";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    blender,
    pandora-launcher,
    my-keyboard,
    ...
  }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              users.vulae = import ./users/vulae/home.nix;
              extraSpecialArgs = { inherit inputs blender pandora-launcher my-keyboard; };
            };
          }
        ];

      };
    };
  };
}
