{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.steam;
in
{
  options.features.steam = {
    enable = mkEnableOption "Steam with Proton-GE, gamemode and mangohud";
  };
  config = mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = false;
        extraCompatPackages = [
          pkgs.proton-ge-bin
        ];
        gamescopeSession.enable = true;
        package = pkgs.steam.override {
          extraPkgs =
            pkgs: with pkgs; [
              # Controller support libraries
              libusb1
              udev
              SDL2

              # Graphics and Vulkan support
              vulkan-loader
              vulkan-validation-layers
              vulkan-tools
              vulkan-extension-layer
              mesa
              libdrm

              # Additional libraries for Marvel Rivals and modern games
              libxcursor
              libxi
              libxinerama
              libxscrnsaver
              libxcomposite
              libxdamage
              libxrender
              libxext

              # Fix for Xwayland symbol errors
              libkrb5
              keyutils
            ];
        };
      };
      gamemode.enable = true;
    };

    # System-level packages
    environment.systemPackages = with pkgs; [
      mangohud
    ];

    # Keep the DXVK pipeline cache across game updates
    environment.sessionVariables.DXVK_STATE_CACHE_PATH = "$HOME/.cache/dxvk";
  };
}
