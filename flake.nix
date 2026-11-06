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

    # Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    textfox = {
      url = "github:adriankarlen/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Zen Browser
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tuicr = {
      url = "github:agavra/tuicr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets (optional, see modules/nixos/homelab.nix)
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative disk layouts for nixos-anywhere installs
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homelab apps, each repo exports packages.<system>.default and is only
    # fetched when the homelab is built (see hosts/homelab/services.nix):
    # my-app = {
    #   url = "github:Pazl27/my-app"; # private repo: "git+ssh://git@github.com/Pazl27/my-app"
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Gruvbox wallpaper collection
    gruvbox-wallpapers.url = "github:AngelJumbo/gruvbox-wallpapers";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      hyprland,
      spicetify-nix,
      textfox,
      noctalia,
      sops-nix,
      disko,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      # Packages defined in ./pkgs (my-scripts, vi-sql)
      overlay = import ./pkgs;

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          overlays = [ overlay ];
          config.allowUnfree = true;
        };

      # type: "nixos" (NixOS + Home Manager) or "home-manager" (standalone)
      hosts = {
        desktop = {
          username = "desktop";
          system = "x86_64-linux";
          type = "nixos";
        };
        homelab = {
          username = "homelab";
          system = "x86_64-linux";
          type = "nixos";
        };
        nix-wsl = {
          username = "nix-wsl";
          system = "x86_64-linux";
          type = "home-manager";
        };
      };

      hostDir = name: ./hosts + "/${name}";

      # Settings shared by both module trees: the typed `host` options,
      # the host's values for them and its identity from the table above.
      hostModules = name: host: [
        ./modules/shared/host.nix
        (hostDir name + "/variables.nix")
        {
          host = {
            inherit name;
            inherit (host) username;
          };
        }
      ];

      # Home Manager configuration of a host's primary user.
      homeModule = name: host: {
        imports = [
          ./modules/home
          (hostDir name + "/home.nix")
          nixvim.homeModules.nixvim
          spicetify-nix.homeManagerModules.default
          hyprland.homeManagerModules.default
          textfox.homeManagerModules.default
          noctalia.homeModules.default
        ]
        ++ hostModules name host;

        home.username = host.username;
        home.homeDirectory = "/home/${host.username}";
      };

      mkHome =
        name: host:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor host.system;
          extraSpecialArgs = { inherit inputs; };
          modules = [ (homeModule name host) ];
        };

      mkNixOS =
        name: host:
        lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            (hostDir name)
            ./modules/nixos
            ./modules/drivers
            hyprland.nixosModules.default
            sops-nix.nixosModules.sops
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              nixpkgs.hostPlatform = host.system;
              nixpkgs.overlays = [ overlay ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                users.${host.username} = homeModule name host;
              };
            }
          ]
          ++ hostModules name host;
        };

      hostsOfType = type: lib.filterAttrs (_: host: host.type == type) hosts;

      forAllSystems = lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      nixvimFor = system: (pkgsFor system).callPackage ./pkgs/nixvim.nix { inherit nixvim; };
    in
    {
      nixosConfigurations = lib.mapAttrs mkNixOS (hostsOfType "nixos");
      homeConfigurations = lib.mapAttrs mkHome (hostsOfType "home-manager");

      overlays.default = overlay;

      packages = forAllSystems (system: {
        inherit (pkgsFor system) my-scripts vi-sql;
        nixvim = nixvimFor system;
      });

      apps = forAllSystems (system: {
        nixvim = {
          type = "app";
          program = "${nixvimFor system}/bin/nvim";
          meta.description = "Neovim with this repository's NixVim configuration";
        };
      });
    };
}
