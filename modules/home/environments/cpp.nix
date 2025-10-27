{ config, lib, pkgs, ... }:

with lib;

{
  options.features.environments.cpp = {
    enable = mkEnableOption "C++ development environment";
  };

  config = mkIf config.features.environments.cpp.enable {
    home.packages = with pkgs; [
      # Compiler and core tools
      gcc
      gnumake
      cmake
      ninja

      # Debugging and profiling
      gdb
      valgrind

      # Additional tools
      clang-tools     # Includes clangd LSP, clang-format
      pkg-config
      cppcheck        # Static analysis
      boost           # Popular C++ library
    ];

    home.sessionVariables = {
      CXX = "g++";
      CC = "gcc";
    };
  };
}
