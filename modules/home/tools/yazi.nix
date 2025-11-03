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

      # ============================================
      # SETTINGS
      # ============================================
      settings = {
        manager = {
          layout = [
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
              run = ''nvim "$@"'';
              block = true;
            }
          ];
          open = [
            {
              run = ''xdg-open "$@"'';
              desc = "Open";
            }
          ];
          reveal = [
            {
              run = ''${pkgs.xdg-utils}/bin/xdg-open "$(dirname "$0")"'';
              desc = "Reveal";
            }
          ];
          extract = [
            {
              run = ''unar "$@"'';
              desc = "Extract here";
            }
          ];
          play = [
            {
              run = ''mpv "$@"'';
              orphan = true;
              desc = "Play";
            }
          ];
        };

        open = {
          rules = [
            {
              mime = "text/*";
              use = "edit";
            }
            {
              mime = "image/*";
              use = "open";
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
      # KEYMAPS
      # ============================================
      keymap = {
        manager.prepend_keymap = [
          # Navigation
          {
            on = [ "h" ];
            run = "leave";
            desc = "Go back";
          }
          {
            on = [ "l" ];
            run = "enter";
            desc = "Enter directory";
          }
          {
            on = [ "k" ];
            run = "arrow -1";
            desc = "Move up";
          }
          {
            on = [ "j" ];
            run = "arrow 1";
            desc = "Move down";
          }

          # Jump
          {
            on = [
              "g"
              "h"
            ];
            run = "cd ~";
            desc = "Go to home";
          }
          {
            on = [
              "g"
              "c"
            ];
            run = "cd ~/.config";
            desc = "Go to config";
          }
          {
            on = [
              "g"
              "d"
            ];
            run = "cd ~/Downloads";
            desc = "Go to downloads";
          }
          {
            on = [
              "g"
              "D"
            ];
            run = "cd ~/Documents";
            desc = "Go to documents";
          }
          {
            on = [
              "g"
              "p"
            ];
            run = "cd ~/Pictures";
            desc = "Go to pictures";
          }
          {
            on = [
              "g"
              "t"
            ];
            run = "cd /tmp";
            desc = "Go to tmp";
          }

          # Operations
          {
            on = [ "y" ];
            run = "yank";
            desc = "Copy";
          }
          {
            on = [ "x" ];
            run = "yank --cut";
            desc = "Cut";
          }
          {
            on = [ "p" ];
            run = "paste";
            desc = "Paste";
          }
          {
            on = [ "d" ];
            run = "remove";
            desc = "Delete";
          }
          {
            on = [ "D" ];
            run = "remove --permanently";
            desc = "Delete permanently";
          }
          {
            on = [ "a" ];
            run = "create";
            desc = "Create";
          }
          {
            on = [ "r" ];
            run = "rename";
            desc = "Rename";
          }

          # Selection
          {
            on = [ "<Space>" ];
            run = "select --state=none";
            desc = "Toggle selection";
          }
          {
            on = [ "v" ];
            run = "visual_mode";
            desc = "Enter visual mode";
          }
          {
            on = [ "V" ];
            run = "visual_mode --unset";
            desc = "Enter visual mode (unset)";
          }
          {
            on = [ "<C-a>" ];
            run = "select_all --state=true";
            desc = "Select all";
          }
          {
            on = [ "<C-r>" ];
            run = "select_all --state=none";
            desc = "Inverse selection";
          }

          # View
          {
            on = [ "i" ];
            run = "peek";
            desc = "Peek";
          }
          {
            on = [ "I" ];
            run = "peek --close";
            desc = "Close peek";
          }
          {
            on = [
              "z"
              "h"
            ];
            run = "hidden toggle";
            desc = "Toggle hidden files";
          }

          # Search
          {
            on = [ "/" ];
            run = "search fd";
            desc = "Search by name";
          }
          {
            on = [ "?" ];
            run = "search rg";
            desc = "Search by content";
          }
          {
            on = [ "n" ];
            run = "search_arrow";
            desc = "Next search result";
          }
          {
            on = [ "N" ];
            run = "search_arrow --previous";
            desc = "Previous search result";
          }

          # Tabs
          {
            on = [ "t" ];
            run = "tab_create --current";
            desc = "New tab";
          }
          {
            on = [ "1" ];
            run = "tab_switch 0";
            desc = "Switch to tab 1";
          }
          {
            on = [ "2" ];
            run = "tab_switch 1";
            desc = "Switch to tab 2";
          }
          {
            on = [ "3" ];
            run = "tab_switch 2";
            desc = "Switch to tab 3";
          }
          {
            on = [ "[" ];
            run = "tab_switch -1 --relative";
            desc = "Previous tab";
          }
          {
            on = [ "]" ];
            run = "tab_switch 1 --relative";
            desc = "Next tab";
          }

          # Sorting
          {
            on = [
              ","
              "a"
            ];
            run = "sort alphabetical --dir_first";
            desc = "Sort alphabetically";
          }
          {
            on = [
              ","
              "A"
            ];
            run = "sort alphabetical --reverse --dir_first";
            desc = "Sort alphabetically (reverse)";
          }
          {
            on = [
              ","
              "m"
            ];
            run = "sort modified --dir_first";
            desc = "Sort by modified time";
          }
          {
            on = [
              ","
              "M"
            ];
            run = "sort modified --reverse --dir_first";
            desc = "Sort by modified time (reverse)";
          }
          {
            on = [
              ","
              "s"
            ];
            run = "sort size --dir_first";
            desc = "Sort by size";
          }
          {
            on = [
              ","
              "S"
            ];
            run = "sort size --reverse --dir_first";
            desc = "Sort by size (reverse)";
          }

          # Other
          {
            on = [ "q" ];
            run = "quit";
            desc = "Quit";
          }
          {
            on = [ "<Esc>" ];
            run = "escape";
            desc = "Escape";
          }
          {
            on = [ "~" ];
            run = "help";
            desc = "Help";
          }
        ];
      };

      # ============================================
      # THEME (Gruvbox Dark Hard)
      # ============================================
      theme = {
        manager = {
          cwd = {
            fg = "#fb4934";
          }; # Bright red

          # Hovered
          hovered = {
            fg = "#1d2021";
            bg = "#fb4934";
          };
          preview_hovered = {
            underline = true;
          };

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

          # Tab
          tab_active = {
            fg = "#1d2021";
            bg = "#fb4934";
          };
          tab_inactive = {
            fg = "#a89984";
            bg = "#3c3836";
          };
          tab_width = 1;

          # Border
          border_symbol = "│";
          border_style = {
            fg = "#665c54";
          };

          # Highlighting
          syntect_theme = "";
        };

        status = {
          separator_open = "";
          separator_close = "";
          separator_style = {
            fg = "#3c3836";
            bg = "#3c3836";
          };

          # Mode
          mode_normal = {
            fg = "#1d2021";
            bg = "#83a598";
            bold = true;
          };
          mode_select = {
            fg = "#1d2021";
            bg = "#b8bb26";
            bold = true;
          };
          mode_unset = {
            fg = "#1d2021";
            bg = "#d3869b";
            bold = true;
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

          # Permissions
          permissions_t = {
            fg = "#b8bb26";
          };
          permissions_r = {
            fg = "#fabd2f";
          };
          permissions_w = {
            fg = "#fb4934";
          };
          permissions_x = {
            fg = "#8ec07c";
          };
          permissions_s = {
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

        select = {
          border = {
            fg = "#83a598";
          };
          active = {
            fg = "#fe8019";
          };
          inactive = { };
        };

        tasks = {
          border = {
            fg = "#83a598";
          };
          title = { };
          hovered = {
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
          on = {
            fg = "#fe8019";
          };
          exec = {
            fg = "#8ec07c";
          };
          desc = {
            fg = "#928374";
          };
          hovered = {
            bg = "#504945";
            bold = true;
          };
          footer = {
            fg = "#3c3836";
            bg = "#ebdbb2";
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

            # Fallback
            {
              name = "*";
              fg = "#ebdbb2";
            }
            {
              name = "*/";
              fg = "#83a598";
            }
          ];
        };
      };
    };

    # Dependencies
    home.packages = with pkgs; [
      yazi

      ffmpegthumbnailer # Video thumbnails
      unar # Archive preview
      poppler-utils

      imagemagick # Image operations
      mpv # Video/Audio player
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
