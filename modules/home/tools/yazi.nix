{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.features.tools.yazi = {
    enable = mkEnableOption "Yazi file manager with Gruvbox theme";
  };

  config = mkIf config.features.tools.yazi.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      shellWrapperName = "yy";

      # ============================================
      # SETTINGS
      # ============================================
      settings = {
        mgr = {
          ratio = [
            1
            4
            3
          ];
          sort_by = "natural";
          sort_sensitive = false;
          sort_reverse = false;
          sort_dir_first = true;
          linemode = "size";
          show_hidden = false;
          show_symlink = true;
        };

        preview = {
          tab_size = 2;
          max_width = 600;
          max_height = 900;
          cache_dir = "";
        };

        opener = {
          edit = [
            {
              run = "nvim %*";
              block = true;
            }
          ];
          open = [
            {
              run = "xdg-open %s1";
              desc = "Open";
            }
          ];
          image = [
            {
              run = "nsxiv %s1";
              desc = "Open";
            }
          ];
          reveal = [
            {
              run = "${pkgs.xdg-utils}/bin/xdg-open %d1";
              desc = "Reveal";
            }
          ];
          extract = [
            {
              run = "unar %*";
              desc = "Extract here";
            }
          ];
          play = [
            {
              run = "mpv %*";
              orphan = true;
              desc = "Play";
            }
          ];
        };

        open = {
          rules = [
            {
              mime = "application/pdf";
              use = "open";
            }
            {
              mime = "text/*";
              use = "edit";
            }
            {
              mime = "image/*";
              use = "image";
            }
            {
              mime = "video/*";
              use = "play";
            }
            {
              mime = "audio/*";
              use = "play";
            }
            {
              mime = "application/json";
              use = "edit";
            }
            {
              mime = "*/javascript";
              use = "edit";
            }
          ];
        };
      };

      # ============================================
      # THEME (Gruvbox Dark Hard)
      # ============================================
      theme = {
        mgr = {
          cwd = {
            fg = "#fb4934";
          }; # Bright red

          # Find
          find_keyword = {
            fg = "#fabd2f";
            italic = true;
          };
          find_position = {
            fg = "#fe8019";
            bg = "reset";
            italic = true;
          };

          # Symlink target
          symlink_target = {
            italic = true;
          };

          # Marker
          marker_selected = {
            fg = "#b8bb26";
            bg = "#b8bb26";
          };
          marker_copied = {
            fg = "#fabd2f";
            bg = "#fabd2f";
          };
          marker_cut = {
            fg = "#fb4934";
            bg = "#fb4934";
          };
          marker_marked = {
            fg = "#8ec07c";
            bg = "#8ec07c";
          };
          marker_symbol = "│";

          # Count badges
          count_copied = {
            fg = "#1d2021";
            bg = "#fabd2f";
          };
          count_cut = {
            fg = "#1d2021";
            bg = "#fb4934";
          };
          count_selected = {
            fg = "#1d2021";
            bg = "#b8bb26";
          };

          # Border
          border_symbol = "│";
          border_style = {
            fg = "#665c54";
          };

          # Highlighting
          syntect_theme = "";
        };

        tabs = {
          active = {
            fg = "#1d2021";
            bg = "#fb4934";
            bold = true;
          };
          inactive = {
            fg = "#a89984";
            bg = "#3c3836";
          };
        };

        mode = {
          normal_main = {
            fg = "#1d2021";
            bg = "#83a598";
            bold = true;
          };
          normal_alt = {
            fg = "#83a598";
            bg = "#3c3836";
          };
          select_main = {
            fg = "#1d2021";
            bg = "#b8bb26";
            bold = true;
          };
          select_alt = {
            fg = "#b8bb26";
            bg = "#3c3836";
          };
          unset_main = {
            fg = "#1d2021";
            bg = "#d3869b";
            bold = true;
          };
          unset_alt = {
            fg = "#d3869b";
            bg = "#3c3836";
          };
        };

        indicator = {
          current = {
            fg = "#1d2021";
            bg = "#fb4934";
          };
          preview = {
            underline = true;
          };
        };

        status = {
          sep_left = {
            open = "";
            close = "";
          };
          sep_right = {
            open = "";
            close = "";
          };

          # Progress
          progress_label = {
            fg = "#ebdbb2";
            bold = true;
          };
          progress_normal = {
            fg = "#83a598";
            bg = "#3c3836";
          };
          progress_error = {
            fg = "#fb4934";
            bg = "#3c3836";
          };

          perm_type = {
            fg = "#b8bb26";
          };
          perm_read = {
            fg = "#fabd2f";
          };
          perm_write = {
            fg = "#fb4934";
          };
          perm_exec = {
            fg = "#8ec07c";
          };
          perm_sep = {
            fg = "#665c54";
          };
        };

        input = {
          border = {
            fg = "#fb4934";
          };
          title = { };
          value = { };
          selected = {
            reversed = true;
          };
        };

        # [select] was renamed to [pick].
        pick = {
          border = {
            fg = "#83a598";
          };
          active = {
            fg = "#fe8019";
            bold = true;
          };
          inactive = { };
        };

        tasks = {
          border = {
            fg = "#83a598";
          };
          title = { };
          hovered = {
            fg = "#fe8019";
            underline = true;
          };
        };

        which = {
          cols = 3;
          mask = {
            bg = "#1d2021";
          };
          cand = {
            fg = "#8ec07c";
          };
          rest = {
            fg = "#928374";
          };
          desc = {
            fg = "#fe8019";
          };
          separator = "  ";
          separator_style = {
            fg = "#504945";
          };
        };

        help = {
          border = {
            fg = "#83a598";
          };
          chord = {
            fg = "#fe8019";
          };
          action = {
            fg = "#8ec07c";
          };
          hovered = {
            bg = "#504945";
            bold = true;
          };
        };

        filetype = {
          rules = [
            # Images
            {
              mime = "image/*";
              fg = "#8ec07c";
            }

            # Videos
            {
              mime = "video/*";
              fg = "#fabd2f";
            }
            {
              mime = "audio/*";
              fg = "#fabd2f";
            }

            # Archives
            {
              mime = "application/zip";
              fg = "#fe8019";
            }
            {
              mime = "application/gzip";
              fg = "#fe8019";
            }
            {
              mime = "application/x-tar";
              fg = "#fe8019";
            }
            {
              mime = "application/x-bzip";
              fg = "#fe8019";
            }
            {
              mime = "application/x-bzip2";
              fg = "#fe8019";
            }
            {
              mime = "application/x-7z-compressed";
              fg = "#fe8019";
            }
            {
              mime = "application/x-rar";
              fg = "#fe8019";
            }

            # Orphan / executable / directory
            {
              url = "*";
              is = "orphan";
              bg = "#fb4934";
            }
            {
              url = "*";
              is = "exec";
              fg = "#b8bb26";
            }

            {
              url = "*";
              fg = "#ebdbb2";
            }
            {
              url = "*/";
              fg = "#83a598";
            }
          ];
        };
      };
    };

    # Dependencies
    home.packages = with pkgs; [
      yazi

      ffmpegthumbnailer
      unar
      poppler-utils

      imagemagick
      nsxiv
      mpv
    ];

    # Shell integration
    programs.zsh.initContent = mkIf config.programs.zsh.enable ''
      # Yazi shell wrapper
      function yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';
  };
}
