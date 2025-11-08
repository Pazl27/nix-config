{
  config,
  lib,
  pkgs,
  ...
}:
{
  # System-wide fonts
  fonts.packages = with pkgs; [
    # Nerd Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.meslo-lg
    nerd-fonts.iosevka
    nerd-fonts.code-new-roman

    # System & UI Fonts
    ubuntu-classic
    liberation_ttf
    dejavu_fonts

    # Coding Fonts
    jetbrains-mono
    fira-code
    source-code-pro

    # Popular Fonts
    roboto
    roboto-mono
    open-sans

    # Emoji
    noto-fonts-color-emoji
    font-awesome
  ];

  # Font configuration
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "DejaVu Serif" ];
      sansSerif = [
        "Ubuntu"
        "DejaVu Sans"
      ];
      monospace = [
        "JetBrains Mono Nerd Font"
        "DejaVu Sans Mono"
      ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
