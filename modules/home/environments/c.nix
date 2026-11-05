{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.environments.c;
in
{
  options.features.environments.c = {
    enable = mkEnableOption "C development environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Compiler and core tools
      gcc
      gnumake

      # Debugging and profiling
      gdb
      valgrind

      # Additional tools
      clang-tools # Includes clangd LSP, clang-format
      pkg-config
      autoconf
      automake
      libtool
    ];

    home.sessionVariables = {
      CC = "gcc";
    };
  };
}
