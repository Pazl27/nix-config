{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  env = import ./env.nix { };
  input = import ./input.nix { };
  layout = import ./layout.nix { };
  appearance = import ./appearance.nix { };
  keybinds = import ./keybinds.nix { };
  startup = import ./startup.nix { };
  outputs = import ./outputs.nix { };
  windowRules = import ./window-rules.nix { };
in
{
  options.features.wm.niri = {
    enable = mkEnableOption "Enable niri Wayland compositor and configuration";
  };

  config = mkIf config.features.wm.niri.enable {
    wayland.systemd.target = "graphical-session.target";

    features.application = {
      rofi.enable = true;
      noctalia.enable = true;
      wlogout.enable = true;
    };

    home.packages = with pkgs; [
      rofi
      grim
      slurp
      grimblast
      wl-clipboard
      cliphist
    ];

    xdg.configFile = {
      "niri/config.kdl".text = ''
        include "env.kdl"
        include "input.kdl"
        include "layout.kdl"
        include "appearance.kdl"
        include "window-rules.kdl"
        include "binds.kdl"
        include "outputs.kdl"
        include "startup.kdl"
      '';
      "niri/env.kdl".text = env;
      "niri/input.kdl".text = input;
      "niri/layout.kdl".text = layout;
      "niri/appearance.kdl".text = appearance;
      "niri/window-rules.kdl".text = windowRules;
      "niri/binds.kdl".text = keybinds;
      "niri/outputs.kdl".text = outputs;
      "niri/startup.kdl".text = startup;
    };
  };
}
