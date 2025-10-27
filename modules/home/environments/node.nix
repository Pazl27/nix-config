{ config, lib, pkgs, ... }:

with lib;

{
  options.features.environments.node = {
    enable = mkEnableOption "Node.js development environment";
  };

  config = mkIf config.features.environments.node.enable {
    home.packages = with pkgs; [
      nodePackages.npm
      nodePackages.pnpm
      nodePackages.yarn
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted  # HTML/CSS/JSON LSP
    ];

    home.sessionVariables = {
      NODE_OPTIONS = "--max-old-space-size=4096";
    };
  };
}