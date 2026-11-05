{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.environments.python;
in
{
  options.features.environments.python = {
    enable = mkEnableOption "Python development environment";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python312
      python312Packages.pip
      python312Packages.virtualenv
      poetry
      ruff # Fast Python linter
      pyright # Python LSP
    ];
  };
}
