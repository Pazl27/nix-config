{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  general = import ./general.nix { };
  exec = import ./exec.nix { };
  keybinds = import ./keybinds.nix { };
  outputs = import ./outputs.nix { };
  rules = import ./rules.nix { };
in
{
  options.features.wm.niri = {
    enable = mkEnableOption "Enable niri Wayland compositor and configuration";
  };

  config = mkIf config.features.wm.niri.enable {
    wayland.systemd.target = "graphical-session.target";

    features.application = {
      rofi.enable = true;
      waybar.enable = true;
      wlogout.enable = true;
      swaync.enable = true;
    };

    # Packages
    home.packages = with pkgs; [
      rofi
      swww

      grim
      slurp
      grimblast

      wl-clipboard
      cliphist
    ];

    # Config files
    xdg.configFile = {
      "niri/config.kdl".text = general;
      "niri/startup.kdl".text = exec;
      "niri/binds.kdl".text = keybinds;
      "niri/outputs.kdl".text = outputs;
      "niri/windowrules.kdl".text = rules;
    };
  };
}
