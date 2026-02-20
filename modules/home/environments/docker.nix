{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.features.environments.docker;
in
{
  options.features.environments.docker = {
    enable = mkEnableOption "Docker and container tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      docker
      docker-compose
      lazydocker # Terminal UI for Docker
      dive # Explore Docker image layers
      ctop # Container metrics
    ];

    xdg.desktopEntries.docker = {
      name = "Docker";
      comment = "Docker Container Management with lazydocker";
      exec = "${pkgs.kitty}/bin/kitty -e ${pkgs.lazydocker}/bin/lazydocker";
      icon = "docker";
      terminal = false;
      type = "Application";
      categories = [ "Development" "System" "Utility" ];
    };
  };
}