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

      # For VMs - software rendering fallback
      mesa
      libglvnd
    ];

    # Configure Zed
    programs.zed-editor = {
      enable = true;

      # Apply settings from zed-settings.nix
      userSettings = zedSettings;

      # Apply keybindings from zed-keybindings.nix
      userKeymaps = zedKeybindings;

      userTasks = zedTasks;
    };

    # Set environment variables for Vulkan
    home.sessionVariables = {
      # Vulkan ICD (Installable Client Driver) path
      VK_ICD_FILENAMES = "${pkgs.mesa}/share/vulkan/icd.d/lvp_icd.x86_64.json";

      # Uncomment for VMs with GPU issues
      # WGPU_BACKEND = "gl";
    };
  };
}
