{ config, lib, pkgs, ... }:

with lib;

{
  options.features.environments.node = {
    enable = mkEnableOption "Node.js development environment";
  };

  config = mkIf config.features.environments.node.enable {
    home.packages = with pkgs; [
      nodejs
      pnpm
      yarn
      typescript
      typescript-language-server
      vscode-langservers-extracted  # HTML/CSS/JSON LSP
    ];

    home.sessionVariables = {
      NODE_OPTIONS = "--max-old-space-size=4096";
    };
  };
}