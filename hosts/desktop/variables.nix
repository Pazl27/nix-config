# Host settings, see modules/shared/host.nix for all options.
{
  host = {
    git = {
      username = "Pazl";
      email = "130466427+Pazl27@users.noreply.github.com";
    };

    windowManager = "niri";
    appLauncher = "launchpad";
    hyprlandLayout = "scrolling";

    gpu = "nvidia";

    boot = {
      device = "nodev";
      efi = true;
    };
    sddmTheme = "japanese_aesthetic";
    virtualCamera = true;

    sshAuthorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7akRGAUqpB2pTJ7jc8gVAhiOSYnxufSc5R3C+7RlHM nix-wsl@DE19352NB"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkXamJpo/wZPSkCfZzX+LudFhUxBXE1JeUC3Goof9gu paul@endevour"
    ];
  };
}
