{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.features.environments.database;
in
{
  options.features.environments.database = {
    enable = mkEnableOption "database tools and applications";

    gui = mkOption {
      type = types.bool;
      default = true;
      description = "Install GUI database management tools";
    };

    cli = mkOption {
      type = types.bool;
      default = true;
      description = "Install CLI database tools";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      # GUI Tools
      (optionals cfg.gui [
        # beekeeper-studio
        dbgate
      ])
      ++
        # CLI Tools
        (optionals cfg.cli [
          postgresql # psql client
          mysql80 # mysql client
          sqlite # sqlite3
          mongosh # MongoDB shell
          redis # redis-cli
        ]);
  };
}
