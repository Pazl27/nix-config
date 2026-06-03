{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.features.application.zen = {
    enable = mkEnableOption "Enable Zen browser";

    default = mkOption {
      type = types.bool;
      default = false;
      description = "Set Zen as the default browser";
    };
  };

  config = mkIf config.features.application.zen.enable {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    # Set as default browser
    xdg.mimeApps = mkIf config.features.application.zen.default {
      enable = true;
      defaultApplications = {
        "text/html" = "zen.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "x-scheme-handler/about" = "zen.desktop";
        "x-scheme-handler/unknown" = "zen.desktop";
      };
    };

    # Set environment variable
    home.sessionVariables = mkIf config.features.application.zen.default {
      BROWSER = "zen";
    };
  };
}
