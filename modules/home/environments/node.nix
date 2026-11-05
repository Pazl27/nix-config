{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.environments.node;
in
{
  options.features.environments.node = {
    enable = mkEnableOption "Node.js development environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs
      pnpm
      yarn
      typescript
      typescript-language-server
      vscode-langservers-extracted # HTML/CSS/JSON LSP
    ];

    home.sessionVariables = {
      NODE_OPTIONS = "--max-old-space-size=4096";
    };
  };
}
