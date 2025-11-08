{
  config,
  lib,
  pkgs,
  ...
}:
let
  vars = config.hostVars;
  useUEFI = vars.useUEFI;
  bootDevice = vars.bootDevice;
in
{
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = bootDevice;
      efiSupport = useUEFI;
      useOSProber = true;

      theme = pkgs.stdenv.mkDerivation {
        pname = "tartarus-grub-theme";
        version = "1.0";

        src = pkgs.fetchFromGitHub {
          owner = "AllJavi";
          repo = "tartarus-grub";
          rev = "b116360a2a0991062a4d728cb005dfd309fbb82a";
          sha256 = "sha256-/Pzr0R3zzOXUi2pAl8Lvg6aHTiwXTIrxQ1vscbEK/kU="; # Updated hash
        };

        installPhase = ''
          mkdir -p $out
          cp -r tartarus/* $out/
        '';
      };
    };
  };
}
