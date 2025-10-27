{ config, lib, pkgs, ... }:

with lib;

{
  options.features.environments.rust = {
    enable = mkEnableOption "Rust development environment";
  };

  config = mkIf config.features.environments.rust.enable {
    home.packages = with pkgs; [
      rustc
      cargo
      rustfmt
      clippy
      rust-analyzer
    ];

    home.sessionVariables = {
      RUST_BACKTRACE = "1";
    };
  };
}