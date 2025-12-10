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

          format = lib.mkForce (
            lib.concatStrings [
              "$directory"
              "$git_branch"
              "$git_commit"
              "$git_state"
              "$git_status"
              "$fill"
              "$package"
              "$rust"
              "$python"
              "$nodejs"
              "$golang"
              "$java"
              "$c"
              "$zig"
              "$docker_context"
              "$nix_shell"
              "$line_break"
              "$character"
            ]
          );

          git_branch = {
            format = lib.mkForce "[$symbol$branch(:$remote_branch)]($style) ";
          };
          fill = {
            symbol = " ";
          };
          package = {
            format = lib.mkForce "[$symbol$version]($style) ";
            disabled = false;
          };
          rust = {
            format = lib.mkForce "[$symbol($version )]($style)";
          };
          python = {
            format = lib.mkForce "[$symbol($version )]($style)";
          };
          nodejs = {
            format = lib.mkForce "[$symbol($version )]($style)";
          };
          golang = {
            format = lib.mkForce "[$symbol($version )]($style)";
          };
          java = {
            format = lib.mkForce "[$symbol($version )]($style)";
          };
          c = {
            format = lib.mkForce "[$symbol($version )]($style)";
          };
          zig = {
            format = lib.mkForce "[$symbol($version )]($style)";
          };
          docker_context = {
            format = lib.mkForce "[$symbol$context ]($style)";
          };
          nix_shell = {
            format = lib.mkForce "[$symbol$state]($style) ";
          };
        }
      ];
    };
  };
}
