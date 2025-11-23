{
  pkgs,
  lib,
  config,
  host,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) sddmTheme;

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
      defaultSession = "hyprland";
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
