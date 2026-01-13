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
      nixd
      jdt-language-server
      gopls
      pyright

      nodePackages.typescript-language-server # For general JS/TS
      nodePackages.vscode-langservers-extracted # HTML, CSS, JSON
      yaml-language-server
      dockerfile-language-server
      docker-compose-language-service
    ];

    home.activation.cleanZedConfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      rm -f ~/.config/zed/keymap.json
      rm -f ~/.config/zed/settings.json
      rm -f ~/.config/zed/tasks.json
    '';

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
          nixd = {
            binary = {
              path = "${pkgs.nixd}/bin/nixd";
            };
          };
          jdtls = {
            binary = {
              path = "${pkgs.jdt-language-server}/bin/jdtls";
            };
          };
          gopls = {
            binary = {
              path = "${pkgs.gopls}/bin/gopls";
            };
          };
          pyright = {
            binary = {
              path = "${pkgs.pyright}/bin/pyright-langserver";
            };
          };
          typescript-language-server = {
            binary = {
              path = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
            };
          };
          yaml-language-server = {
            binary = {
              path = "${pkgs.yaml-language-server}/bin/yaml-language-server";
            };
          };
          dockerfile-language-server = {
            binary = {
              path = "${pkgs.dockerfile-language-server}/bin/docker-langserver";
            };
          };
        };
      };
      userKeymaps = zedKeybindings;
      userTasks = zedTasks;
      extensions = [
        "nix"
        "java"
        "go"
        "python"
        "toml"
        "git-firefly"
        "dockerfile"
        "docker-compose"
        "make"
        "catppuccin-icons"
        "log"
        "ini"
        "env"
        "gruvbox-baby"
        "context7-mcp"
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
