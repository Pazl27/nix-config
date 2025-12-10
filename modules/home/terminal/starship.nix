{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.features.terminal.starship = {
    enable = mkEnableOption "starship prompt";
  };

  config = mkIf config.features.terminal.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = lib.mkMerge [
        (builtins.fromTOML (
          builtins.readFile "${pkgs.starship}/share/starship/presets/nerd-font-symbols.toml"
        ))
        {
          add_newline = true;

          git_branch = {
            format = "[$symbol$branch(:$remote_branch)]($style) ";
          };
        }
      ];
    };
  };
}
