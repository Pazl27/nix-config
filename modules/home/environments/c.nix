{ config, lib, pkgs, ... }:

with lib;

{
  options.features.environments.c = {
    enable = mkEnableOption "C development environment";
  };

  config = mkIf config.features.environments.c.enable {
    home.packages = with pkgs; [
      # Compiler and core tools
      gcc
      gnumake

      # Debugging and profiling
      gdb
      valgrind

      # Additional tools
      clang-tools  # Includes clangd LSP, clang-format
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
