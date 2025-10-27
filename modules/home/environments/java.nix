{ config, lib, pkgs, ... }:

with lib;

{
  options.features.environments.java = {
    enable = mkEnableOption "Java development environment";
  };

  config = mkIf config.features.environments.java.enable {
    home.packages = with pkgs; [
      # Java Development Kit
      jdk21

      # Build tools
      maven
      gradle

      # Additional tools
      jdt-language-server  # For LSP support
      google-java-format   # Code formatter
    ];

    home.sessionVariables = {
      JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
    };
  };
}
