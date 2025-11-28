{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.application.obs = {
    enable = mkEnableOption "Enable OBS";
  };

  config = mkIf config.features.application.obs.enable {
    programs.obs-studio = {
      enable = true;

      # optional Nvidia hardware acceleration
      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );

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
