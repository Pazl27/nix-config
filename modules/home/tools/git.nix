{
  config,
  lib,
  pkgs,
  host,
  ...
}:
with lib;
let
  inherit (import ../../../hosts/${host}/variables.nix) gitUsername gitEmail;
in
{
  options.features.tools.git = {
    enable = mkEnableOption "git version control";
  };

  config = mkIf config.features.tools.git.enable {
    home.packages = with pkgs; [
      serie
    ];
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "${gitUsername}";
          email = "${gitEmail}";
        };

        alias = {
          co = "checkout";
          ci = "commit";
        };

        core = {
          pager = "delta";
        };

        init = {
          defaultBranch = "master";
        };

        interactive = {
          diffFilter = "delta --color-only";
        };

        merge = {
          conflictStyle = "zdiff3";
          tool = "nvimdiff";
        };

        "mergetool \"nvimdiff\"" = {
          layout = "LOCAL,MERGED,REMOTE";
        };

        blame = {
          coloring = "highlightRecent";
          date = "relative";
        };

        diff = {
          context = 3;
          renames = "copies";
          interHunkContext = 10;
        };

        log = {
          abbrevCommit = true;
          graphColors = "blue,yellow,cyan,magenta,green,red";
        };

        status = {
          branch = true;
          short = true;
          showStash = true;
          showUntrackedFiles = "all";
        };

        "color \"status\"" = {
          added = "green";
          changed = "yellow";
          untracked = "red";
          branch = "magenta";
          header = "cyan";
        };
      };
    };

    programs.delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;

        # Gruvbox Dark colors
        syntax-theme = "gruvbox-dark";

        # Line numbers
        line-numbers-left-format = "{nm:>4}┊";
        line-numbers-right-format = "{np:>4}│";
        line-numbers-left-style = "#504945";
        line-numbers-right-style = "#504945";
        line-numbers-minus-style = "#fb4934";
        line-numbers-plus-style = "#b8bb26";
        line-numbers-zero-style = "#504945";

        # File headers
        file-style = "#fabd2f bold";
        file-decoration-style = "#fabd2f ul";
        file-added-label = "[+]";
        file-copied-label = "[==]";
        file-modified-label = "[*]";
        file-removed-label = "[-]";
        file-renamed-label = "[->]";

        # Hunk headers
        hunk-header-style = "file line-number syntax";
        hunk-header-decoration-style = "#83a598 box";

        # Diff colors
        minus-style = "syntax #3c1f1e";
        minus-emph-style = "syntax #8b3434";
        plus-style = "syntax #283b1e";
        plus-emph-style = "syntax #40591e";

        # Whitespace
        whitespace-error-style = "#fb4934 reverse";

        # Commit decoration
        commit-decoration-style = "#d79921 box";
        commit-style = "#d79921 bold";

        # Blame
        blame-palette = "#1d2021 #282828 #3c3836 #504945";

        # Merge conflicts
        merge-conflict-begin-symbol = "⌃";
        merge-conflict-end-symbol = "⌄";
        merge-conflict-ours-diff-header-style = "#fabd2f bold";
        merge-conflict-theirs-diff-header-style = "#83a598 bold";
      };
    };

    # Lazygit configuration
    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          pagers = [
            {
              colorArg = "always";
              pager = "delta --dark --paging=never";
            }
          ];
        };

        gui = {
          # Gruvbox Dark Theme
          theme = {
            lightTheme = false;

            # Borders
            activeBorderColor = [
              "#d79921"
              "bold"
            ];
            inactiveBorderColor = [ "#504945" ];
            searchingActiveBorderColor = [ "#fabd2f" ];

            # Text colors
            optionsTextColor = [ "#83a598" ];
            selectedLineBgColor = [ "#3c3836" ];
            selectedRangeBgColor = [ "#3c3836" ];
            cherryPickedCommitBgColor = [ "#b16286" ];
            cherryPickedCommitFgColor = [ "#d79921" ];
            unstagedChangesColor = [ "#fb4934" ];
            defaultFgColor = [ "#ebdbb2" ];
          };

          commitLength = {
            show = true;
          };
        };

        os = {
          editPreset = "nvim";
        };
      };
    };
  };
}
