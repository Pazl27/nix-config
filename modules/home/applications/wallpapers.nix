{
  inputs,
  pkgs,
  ...
}:
{
  home.file."Pictures/wallpaper/gruvbox" = {
    source = inputs.gruvbox-wallpapers.packages.${pkgs.stdenv.hostPlatform.system}.default;
    recursive = true;
  };
}
