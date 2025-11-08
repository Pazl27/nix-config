{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  # Import settings and keybindings
  zedSettings = import ./zed-settings.nix { inherit pkgs; };
  zedKeybindings = import ./zed-keybindings.nix;
  zedTasks = import ./zed-tasks.nix;
in
{
  options.features.editors.zed = {
    enable = mkEnableOption "Zed editor";
  };

  config = mkIf config.features.editors.zed.enable {
    # Install Zed and dependencies
    home.packages = with pkgs; [
      # Vulkan support (required for Zed's GPU acceleration)
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      vulkan-extension-layer

      # LSP servers
      rust-analyzer
      nil
      nixd
    ];

    # Configure Zed
    programs.zed-editor = {
      enable = true;

      # Apply settings with LSP configs
      userSettings = zedSettings // {
        lsp = {
          rust-analyzer = {
            binary = {
              path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            };
            initialization_options = {
              checkOnSave = {
                command = "clippy";
              };
            };
          };

          nil = {
            binary = {
              path = "${pkgs.nil}/bin/nil";
            };
          };

          nixd = {
            binary = {
              path = "${pkgs.nixd}/bin/nixd";
            };
          };
        };
      };

      userKeymaps = zedKeybindings;
      userTasks = zedTasks;

      extensions = [
        "nix"
      ];
    };

    home.sessionVariables = {
      # Point to NVIDIA Vulkan driver
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
      VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

      # Force NVIDIA
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
    };

    programs.zsh.shellAliases = mkIf config.features.editors.zed.enable {
      zed = "zeditor";
    };
  };
}
