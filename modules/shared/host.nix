# Per-host settings, shared by the NixOS and Home Manager module trees.
#
# Every host sets these in `hosts/<name>/variables.nix`; modules read them
# through `config.host.*` instead of importing host files by path.
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.host = {
    name = mkOption {
      type = types.str;
      description = "Name of the host (flake attribute and hostname).";
    };

    username = mkOption {
      type = types.str;
      description = "Primary user of the host.";
    };

    git = {
      username = mkOption {
        type = types.str;
        description = "Name used for git commits.";
      };
      email = mkOption {
        type = types.str;
        description = "Email used for git commits.";
      };
    };

    windowManager = mkOption {
      type = types.nullOr (
        types.enum [
          "hyprland"
          "niri"
        ]
      );
      default = null;
      description = "Wayland compositor to enable, or null for a headless host.";
    };

    appLauncher = mkOption {
      type = types.enum [
        "default"
        "launchpad"
      ];
      default = "default";
      description = "Rofi theme used by the application launcher keybind.";
    };

    hyprlandLayout = mkOption {
      type = types.enum [
        "dwindle"
        "scrolling"
      ];
      default = "dwindle";
      description = "Hyprland tiling layout.";
    };

    gpu = mkOption {
      type = types.nullOr (types.enum [ "nvidia" ]);
      default = null;
      description = "Dedicated GPU vendor, or null for none / integrated graphics.";
    };

    boot = {
      device = mkOption {
        type = types.str;
        default = "nodev";
        description = "GRUB install device (`nodev` for UEFI).";
      };
      efi = mkOption {
        type = types.bool;
        default = true;
        description = "Whether the host boots via UEFI.";
      };
    };

    sddmTheme = mkOption {
      type = types.str;
      default = "astronaut";
      description = "Embedded theme of sddm-astronaut.";
    };

    virtualCamera = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the OBS virtual camera kernel module.";
    };

    sshAuthorizedKeys = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Public keys allowed to log in as the primary user.";
    };
  };
}
