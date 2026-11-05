{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.environments.rust;
in
{
  options.features.environments.rust = {
    enable = mkEnableOption "Rust development environment";
  };

  config = mkIf cfg.enable {
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
