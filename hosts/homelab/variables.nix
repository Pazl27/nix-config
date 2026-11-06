# Host settings, see modules/shared/host.nix for all options.
# Headless: windowManager stays null, which also turns off features.desktop.
{
  host = {
    git = {
      username = "Pazl";
      email = "130466427+Pazl27@users.noreply.github.com";
    };

    sshAuthorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7akRGAUqpB2pTJ7jc8gVAhiOSYnxufSc5R3C+7RlHM nix-wsl@DE19352NB"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkXamJpo/wZPSkCfZzX+LudFhUxBXE1JeUC3Goof9gu paul@endevour"
    ];
  };
}
