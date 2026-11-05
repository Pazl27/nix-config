{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.tools.superfile;
in
{
  options.features.tools.superfile = {
    enable = mkEnableOption "Superfile file manager with Gruvbox theme";
  };

  config = mkIf cfg.enable {
    programs.superfile = {
      enable = true;

      settings = {
        theme = "gruvbox";
        transparent_background = true;
        auto_check_update = false;
        ignore_missing_fields = true;
      };
    };
  };
}
