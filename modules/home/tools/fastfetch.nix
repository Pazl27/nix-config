{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.features.tools.fastfetch = {
    enable = mkEnableOption "fastfetch system information tool";
  };

  config = mkIf config.features.tools.fastfetch.enable {
    home.packages = with pkgs; [
      fastfetch
    ];

    # Configure fastfetch
    home.file.".config/fastfetch/config.jsonc".text = ''
      {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
          "logo": {
            "type": "kitty-direct",
            "source": "$HOME/.config/fastfetch/pngs/gruvbox_pochita.png",
            "width": 34,
            "height": 15 
          },
          "modules": [
            {
              "type": "custom",
              "format": "┌────────── Hardware Information ──────────┐"
            },
            {"type": "cpu", "key":" ", "format": "{1}"},
            {"type": "memory", "key":" "},
            {"type": "host", "key":" "},
            {
              "type": "custom",
              "format": "├────────── Software Information ──────────┤"
            },
            {"type": "users", "key": " ", "compact": true},
            {"type": "os", "key": "󰣇 " },
            {"type": "kernel", "key": ""},
            {"type": "wm", "key": " "},
            {"type": "editor", "key": " "},
            {"type": "shell", "key": " "},
            {"type": "terminal", "key": " "},
            {"type": "packages", "key": " "},
            {"type": "localip", "key": " ", "compact": true},
            {
              "type": "custom",
              "format": "      {#1;33}󰮯 {#0}  {#1;33}• • •{#0}  {#1;31}󰊠 {#0}  {#1;35}󰊠 {#0}  {#1;36}󰊠 {#0}  {#1;34}󰊠 {#0}  {#1;32}󰊠 "
            },
            {
              "type": "custom",
              "format": "└─────────────────────────────────────────┘"
            },
            {
              "type": "custom",
              "format": "      {#1;36} {#0}  {#1;32} {#0}  {#1;33} {#0}  {#1;34}   {#1;31}   {#1;35}   {#1;37}   {#1;90} "
            }
          ]
        }
    '';

    # Optional: Add some shell aliases
    programs.zsh.shellAliases = mkIf config.features.terminal.zsh.enable {
      ff = "fastfetch";
    };

    home.file.".config/fastfetch/pngs" = {
      source = ../../../assets/fastfetch;
      recursive = true;
    };
  };
}
