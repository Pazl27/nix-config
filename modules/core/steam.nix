{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.core.steam;
in
{
  options.core.steam = {
    enable = mkEnableOption "Enable Steam";
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
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              xorg.libXcomposite
              xorg.libXdamage
              xorg.libXrender
              xorg.libXext

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

    # Shader cache optimization for NVIDIA
    environment.sessionVariables = {
      # NVIDIA shader disk cache
      __GL_SHADER_DISK_CACHE = "1";
      __GL_SHADER_DISK_CACHE_PATH = "$HOME/.cache/nvidia";
      __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";

      # DXVK optimizations
      DXVK_STATE_CACHE_PATH = "$HOME/.cache/dxvk";

      # Enable RADV optimizations (also helps with general Vulkan)
      RADV_PERFTEST = "gpl";
    };
  };
}
