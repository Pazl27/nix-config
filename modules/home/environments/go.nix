{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.environments.go;
in
{
  options.features.environments.go = {
    enable = mkEnableOption "Go development environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      go
      gopls # Go LSP
      go-tools # staticcheck, etc.
    ];

    home.sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/go";
      GOBIN = "${config.home.homeDirectory}/go/bin";
    };
  };
}
