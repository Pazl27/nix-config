{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.applications.wallpapers;
in
{
  options.features.applications.wallpapers = {
    enable = mkEnableOption "Gruvbox wallpaper collection in ~/Pictures/wallpaper/gruvbox";
  };

  config = mkIf cfg.enable {
    home.file."Pictures/wallpaper/gruvbox" = {
      source = inputs.gruvbox-wallpapers.packages.${pkgs.stdenv.hostPlatform.system}.default;
      recursive = true;
    };
  };
}
