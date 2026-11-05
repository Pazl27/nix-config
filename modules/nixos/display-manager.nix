{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (config.host) windowManager sddmTheme;

  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = sddmTheme;
  };
in
{
  config = mkIf (windowManager != null) {
    environment.systemPackages = [ sddm-astronaut ];

    services.displayManager = {
      defaultSession = windowManager;
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "sddm-astronaut-theme";
        extraPackages = [ sddm-astronaut ];
      };
    };
  };
}
