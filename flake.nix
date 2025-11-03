{
  description = "NixOS & Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-cli = {
      url = "github:AvengeMedia/danklinux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
      inputs.dms-cli.follows = "dms-cli";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      dankMaterialShell,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      hosts = {
        nix-wsl = {
          username = "nix-wsl";
          homeDirectory = "/home/nix-wsl";
          hostConfig = ./hosts/wsl;
          isNixOS = false;
        };

        nixvm = {
          username = "nixvm";
          homeDirectory = "/home/nixvm";
          hostConfig = ./hosts/nix-vm;
          isNixOS = true;
        };
      };

      mkHome =
        name:
        {
          username,
          homeDirectory,
          hostConfig,
          ...
        }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            (hostConfig + "/home.nix")
            nixvim.homeModules.nixvim
            dankMaterialShell.homeModules.dankMaterialShell.default
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ];
        };

      mkNixOS =
        name:
        {
          username,
          homeDirectory,
          hostConfig,
          ...
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            hostConfig

            # Import NixOS modules
            ./modules/drivers
            ./modules/core

            # Integrate Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = {
                imports = [
                  ./home.nix
                  (hostConfig + "/home.nix")
                  nixvim.homeModules.nixvim
                  dankMaterialShell.homeModules.dankMaterialShell.default
                ];
                home.username = username;
                home.homeDirectory = homeDirectory;
              };
            }
          ];
        };

      standaloneHosts = nixpkgs.lib.filterAttrs (name: host: !host.isNixOS) hosts;
      nixosHosts = nixpkgs.lib.filterAttrs (name: host: host.isNixOS) hosts; # Fixed: was using nixosHosts instead of hosts

    in
    {
      homeConfigurations = builtins.mapAttrs mkHome standaloneHosts;
      nixosConfigurations = builtins.mapAttrs mkNixOS nixosHosts;
    };
}
