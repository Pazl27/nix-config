{
  # ╔════════════════════════════════════════╗
  # ║  SYSTEM CONFIGURATIOe                  ║
  # ╚════════════════════════════════════════╝
  bootDevice = "nodev";
  useUEFI = true;
  sddmTheme = "japanese_aesthetic";
  virtualCamera = true;

  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7akRGAUqpB2pTJ7jc8gVAhiOSYnxufSc5R3C+7RlHM nix-wsl@DE19352NB"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkXamJpo/wZPSkCfZzX+LudFhUxBXE1JeUC3Goof9gu paul@endevour"
  ];

  # ╔════════════════════════════════════════╗
  # ║  USER CONFIGURATION                    ║
  # ╚════════════════════════════════════════╝
  gitUsername = "Pazl";
  gitEmail = "130466427+Pazl27@users.noreply.github.com";
  window_manager = "hyprland"; # Options: "hyprland" (default), "niri", or "" (defaults to hyprland)
  app_launcher = "launchpad"; # Options: "default" or "launchpad"
  hyprland_layout = "scrolling"; # Options: "dwindle" or "scrolling"
}
