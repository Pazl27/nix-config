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

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    # Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pokemon-icat = {
      url = "github:Pazl27/pokemon-icat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    textfox = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      hyprland,
      hyprland-plugins,
      spicetify-nix,
      dankMaterialShell,
      pokemon-icat,
      textfox,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      myScripts = pkgs.callPackage ./pkgs/scripts.nix { };
      myNixvim = pkgs.callPackage ./pkgs/nixvim.nix {
        inherit nixvim;
      };

      # Define your hosts
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
        desktop = {
          username = "desktop";
          homeDirectory = "/home/desktop";
          hostConfig = ./hosts/desktop;
          isNixOS = true;
        };
      };

      # Home Manager only (non-NixOS)
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
          extraSpecialArgs = {
            inherit inputs;
            host = name;
          };
          modules = [
            ./home.nix
            (hostConfig + "/home.nix")
            nixvim.homeModules.nixvim
            spicetify-nix.homeManagerModules.default
            dankMaterialShell.homeModules.dank-material-shell
            hyprland.homeManagerModules.default
            textfox.homeManagerModules.default
            pokemon-icat.homeManagerModules.default
            {
              home.file.".config/scripts".source = "${myScripts}/share/scripts";
            }
            { config._module.args.host = name; }
            {
              home.username = username;
              home.homeDirectory = homeDirectory;
            }
          ];
        };

      # NixOS systems (with integrated Home Manager)
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
          specialArgs = {
            inherit inputs;
            host = name;
          };
          modules = [
            hostConfig
            # Import NixOS modules
            ./modules/drivers
            ./modules/core
            # Add Hyprland NixOS module
            hyprland.nixosModules.default
            # Integrate Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                host = name;
              };
              home-manager.users.${username} = {
                imports = [
                  ./home.nix
                  (hostConfig + "/home.nix")
                  nixvim.homeModules.nixvim
                  spicetify-nix.homeManagerModules.default
                  dankMaterialShell.homeModules.dankMaterialShell.default
                  hyprland.homeManagerModules.default
                  textfox.homeManagerModules.default
                  pokemon-icat.homeManagerModules.default
                  {
                    home.file.".config/scripts".source = "${myScripts}/share/scripts";
                  }
                  { config._module.args.host = name; }
                ];
                home.username = username;
                home.homeDirectory = homeDirectory;
              };
            }
          ];
        };

      # Split hosts
      standaloneHosts = nixpkgs.lib.filterAttrs (name: host: !host.isNixOS) hosts;
      nixosHosts = nixpkgs.lib.filterAttrs (name: host: host.isNixOS) hosts;
    in
    {
      # Build Home Manager configurations (for non-NixOS)
      homeConfigurations = builtins.mapAttrs mkHome standaloneHosts;

      # Build NixOS configurations
      nixosConfigurations = builtins.mapAttrs mkNixOS nixosHosts;

      packages.${system} = {
        my-scripts = myScripts;
        nixvim = myNixvim;
        default = myNixvim;
      };

      apps.${system} = {
        nixvim = {
          type = "app";
          program = "${myNixvim}/bin/nvim";
        };
      };
    };
}
