{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.environments.python = {
    enable = mkEnableOption "Python development environment";
  };
  config = mkIf config.features.environments.python.enable {
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
