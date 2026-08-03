{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.features.tools.tuicr;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.features.tools.tuicr = {
    enable = mkEnableOption "tuicr terminal UI code reviewer";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.tuicr.packages.${pkgs.system}.default
      pkgs.gh
    ];

    xdg.configFile."tuicr/config.toml".source = tomlFormat.generate "tuicr-config.toml" {
      theme = "gruvbox-dark";
      diff_view = "unified";
      ignore_whitespace = false;
      appearance = "system";
      mouse = true;
      leader = ";";
      comment_vim = true;
      relative_line_numbers = false;
      review_watch_interval_ms = 1000;

      comment_types = [
        {
          id = "issue";
          color = "red";
          definition = "must fix before merge";
        }
        {
          id = "suggestion";
          color = "blue";
          definition = "possible improvement, consider or explain why not";
        }
        {
          id = "refactor";
          color = "magenta";
          definition = "restructure without changing behavior";
        }
        {
          id = "praise";
          color = "green";
          definition = "looks good, highlight something done well";
        }
      ];
    };
  };
}
