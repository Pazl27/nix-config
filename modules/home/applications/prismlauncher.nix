{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.applications.prismlauncher;
in
{
  options.features.applications.prismlauncher = {
    enable = mkEnableOption "Prism Launcher for Minecraft";
  };

  config = mkIf cfg.enable {
    # Minecraft needs a JDK
    features.environments.java.enable = true;

    home.packages = [ pkgs.prismlauncher ];
  };
}
