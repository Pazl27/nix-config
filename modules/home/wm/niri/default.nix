{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  niriConfig = import ./niri-config.nix { };
  dmsConfig = import ./dms-config.nix {
    homeDirectory = config.home.homeDirectory;
  };
in
{
  options.features.wm.niri = {
    enable = mkEnableOption "Enable niri Wayland compositor and configuration";
  };

  config = mkIf config.features.wm.niri.enable {
    programs.dankMaterialShell = {
      enable = true;
      enableSystemd = true;
    };

    wayland.systemd.target = "graphical-session.target";

    # Packages
    home.packages = with pkgs; [
      rofi
      grim
      wl-clipboard
    ];

    # Config files
    xdg.configFile = {
      "niri/config.kdl".text = niriConfig;

      "DankMaterialShell/settings.json".text = builtins.toJSON dmsConfig.dmsSettings;

      "DankMaterialShell/gruvbox-theme.json".text = builtins.toJSON dmsConfig.gruvboxTheme;
    };
  };
}
