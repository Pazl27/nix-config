{
  pkgs,
  lib,
  config,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) sddmTheme window_manager;
  
  # Determine default session based on window manager
  defaultSession = if window_manager == "niri" then "niri" else "hyprland";

  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = sddmTheme;
  };
in
{
  environment.systemPackages = [
    sddm-astronaut
  ];

  services = {
    xserver.enable = true;

    displayManager = {
      defaultSession = defaultSession;
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;

        theme = "sddm-astronaut-theme";

        extraPackages = [ sddm-astronaut ];
      };
      autoLogin = {
        enable = false;
        user = "nix-vm";
      };
    };
  };
}
