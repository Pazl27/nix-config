{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.prismlauncher = {
    enable = mkEnableOption "Prism Launcher for Minecraft";

    enableNvidiaOptimizations = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NVIDIA-specific optimizations";
    };
  };

  config = mkIf config.features.application.prismlauncher.enable {
    # Aktiviere automatisch das Java-Modul
    features.environments.java.enable = true;

    # Installiere zusätzliche Java-Versionen für Minecraft
    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
