{
  description = "NixOS, nix-darwin & Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
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
      nix-darwin,
      nixvim,
      hyprland,
      hyprland-plugins,
      spicetify-nix,
      pokemon-icat,
      textfox,
      ...
    }@inputs:
    let
      # Helper to get pkgs for a system
      pkgsFor = system: nixpkgs.legacyPackages.${system};

      # Helper to get scripts for a system
      scriptsFor = system: (pkgsFor system).callPackage ./pkgs/scripts.nix { };

      # Helper to get nixvim for a system
      nixvimFor = system: (pkgsFor system).callPackage ./pkgs/nixvim.nix { inherit nixvim; };

      # Define your hosts
      # type can be: "nixos", "darwin", or "home-manager"
      hosts = {
        nix-wsl = {
          username = "nix-wsl";
          homeDirectory = "/home/nix-wsl";
          hostConfig = ./hosts/wsl;
          system = "x86_64-linux";
          type = "home-manager";
        };
        nixvm = {
          username = "nixvm";
          homeDirectory = "/home/nixvm";
          hostConfig = ./hosts/nix-vm;
          system = "x86_64-linux";
          type = "nixos";
        };
        desktop = {
          username = "desktop";
          homeDirectory = "/home/desktop";
          hostConfig = ./hosts/desktop;
          system = "x86_64-linux";
          type = "nixos";
        };
      };

      # Home Manager only (standalone, for non-NixOS Linux like WSL)
      mkHome =
        name:
        {
          username,
          homeDirectory,
          hostConfig,
          system,
          ...
        }:
        let
          pkgs = pkgsFor system;
          myScripts = scriptsFor system;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            host = name;
          };
          modules = [
            ./home.nix
            (hostConfig + "/home.nix")
            ./modules/core
            nixvim.homeModules.nixvim
            spicetify-nix.homeManagerModules.default
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
          system,
          ...
        }:
        let
          myScripts = scriptsFor system;
        in
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
            ./modules/nixos
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

      # Darwin systems (with integrated Home Manager)
      mkDarwin =
        name:
        {
          username,
          homeDirectory,
          hostConfig,
          system,
          ...
        }:
        let
          myScripts = scriptsFor system;
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            host = name;
          };
          modules = [
            hostConfig
            # Import cross-platform modules
            ./modules/core
            # Import darwin-specific modules
            ./modules/darwin
            # Integrate Home Manager
            home-manager.darwinModules.home-manager
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

      # Filter hosts by type
      hostsByType = type: nixpkgs.lib.filterAttrs (name: host: host.type == type) hosts;

      standaloneHosts = hostsByType "home-manager";
      nixosHosts = hostsByType "nixos";
      darwinHosts = hostsByType "darwin";

      # For packages/apps, support multiple systems
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    {
      # Build Home Manager configurations (for standalone home-manager)
      homeConfigurations = builtins.mapAttrs mkHome standaloneHosts;

      # Build NixOS configurations
      nixosConfigurations = builtins.mapAttrs mkNixOS nixosHosts;

      # Build Darwin configurations
      darwinConfigurations = builtins.mapAttrs mkDarwin darwinHosts;

      packages = forAllSystems (
        system:
        let
          myScripts = scriptsFor system;
          myNixvim = nixvimFor system;
        in
        {
          my-scripts = myScripts;
          nixvim = myNixvim;
        }
      );

      apps = forAllSystems (
        system:
        let
          myNixvim = nixvimFor system;
        in
        {
          nixvim = {
            type = "app";
            program = "${myNixvim}/bin/nvim";
          };
        }
      );
    };
}
