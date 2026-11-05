{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.features.applications.obs;
  nvidia = config.host.gpu == "nvidia";
in
{
  options.features.applications.obs = {
    enable = mkEnableOption "OBS";
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;

      # NVENC hardware encoding needs CUDA
      package = pkgs.obs-studio.override { cudaSupport = nvidia; };

      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
