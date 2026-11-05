{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.features.wm.niri;

  # Each section file returns KDL text and receives `config.host`.
  # The order is the include order in config.kdl.
  sections = [
    {
      name = "env";
      file = ./env.nix;
    }
    {
      name = "input";
      file = ./input.nix;
    }
    {
      name = "layout";
      file = ./layout.nix;
    }
    {
      name = "appearance";
      file = ./appearance.nix;
    }
    {
      name = "window-rules";
      file = ./window-rules.nix;
    }
    {
      name = "binds";
      file = ./keybinds.nix;
    }
    {
      name = "outputs";
      file = ./outputs.nix;
    }
    {
      name = "startup";
      file = ./startup.nix;
    }
  ];
in
{
  options.features.wm.niri = {
    enable = mkEnableOption "niri Wayland compositor and its desktop components";
  };

  config = mkIf cfg.enable {
    wayland.systemd.target = "graphical-session.target";

    features.applications = {
      kitty.enable = mkDefault true; # terminal used by binds and rofi
      noctalia.enable = mkDefault true;
      rofi.enable = mkDefault true;
      wallpapers.enable = mkDefault true;
      wlogout.enable = mkDefault true;
    };

    home.packages = with pkgs; [
      grim
      slurp
      grimblast
      wl-clipboard
      cliphist

      xwayland-satellite
    ];

    xdg.configFile = {
      "niri/config.kdl".text = lib.concatMapStrings (s: "include \"${s.name}.kdl\"\n") sections;
    }
    // lib.listToAttrs (
      map (s: lib.nameValuePair "niri/${s.name}.kdl" { text = import s.file config.host; }) sections
    );
  };
}
