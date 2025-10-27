{ config, lib, pkgs, ... }:

with lib;

{
  options.features.environments.go = {
    enable = mkEnableOption "Go development environment";
  };

  config = mkIf config.features.environments.go.enable {
    home.packages = with pkgs; [
      go
      gopls  # Go LSP
      gotools
      go-tools  # staticcheck, etc.
    ];

    home.sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/go";
      GOBIN = "${config.home.homeDirectory}/go/bin";
    };
  };
}