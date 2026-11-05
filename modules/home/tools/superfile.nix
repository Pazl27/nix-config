{
  config,
  lib,
  ...
}:
with lib;
{
  options.features.tools.superfile = {
    enable = mkEnableOption "Superfile file manager with Gruvbox theme";
  };

  config = mkIf config.features.tools.superfile.enable {
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
