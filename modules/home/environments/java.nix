{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.environments.java;
in
{
  options.features.environments.java = {
    enable = mkEnableOption "Java development environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Java Development Kit
      jdk21

      # Build tools
      maven
      gradle

      # Additional tools
      jdt-language-server # For LSP support
      google-java-format # Code formatter
    ];

    home.sessionVariables = {
      JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
    };
  };
}
