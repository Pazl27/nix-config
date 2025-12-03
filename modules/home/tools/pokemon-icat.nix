{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
{
  options.features.tools.pokemon = {
    enable = mkEnableOption "enable pokemon-icat";
  };
  config = mkIf config.features.tools.pokemon.enable {
    programs.pokemon-icat = {
      enable = true;
      spritesCommit = "e1d237e02b8c0b385c644f184f26720909a82132";
      spritesHash = "sha256-Xow5hkO/Dy+prVvQr9nGuNX/IzooPvcCCzAnd3yWlPI=";
      upscaleFactor = 3.0;
    };

    # Add pokemon-icat to the end of zshrc
    programs.zsh.initContent = ''
      # Show a random Pokemon on shell start
      pokemon-icat
    '';
  };
}
