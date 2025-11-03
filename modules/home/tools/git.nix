{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

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
          name = "Pazl";
          email = "130466427+Pazl27@users.noreply.github.com";
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
      };
    };

    # Lazygit configuration
    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          pagers = [
            # ← Eckige Klammern für Array!
            {
              colorArg = "always";
              pager = "delta --dark --paging=never";
            }
          ];
        };
      };
    };
  };
}
