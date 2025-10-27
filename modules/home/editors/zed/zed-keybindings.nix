[
  # Global key bindings
  {
    bindings = {
      "ctrl-j" = "menu::SelectNext";
      "ctrl-k" = "menu::SelectPrevious";
      "ctrl-p" = null;
    };
  }

  # VimControl (normal & visual mode)
  {
    context = "VimControl && !menu";
    bindings = {
      ":" = "command_palette::Toggle";

      # Formatting and diagnostics
      "space x f" = "editor::Format";
      "space x x" = "diagnostics::Deploy";

      # Buffer management
      "space b d" = "pane::CloseActiveItem";
      "space s v" = "pane::SplitVertical";
      "space s h" = "pane::SplitHorizontal";

      # Code actions
      "space c a" = "editor::ToggleCodeActions";
      "shift-k" = "editor::Hover";
      "shift-u" = "vim::Redo";
      "space r n" = "editor::Rename";

      # Panels
      "space c c" = "workspace::ToggleRightDock";
      "space c i" = "assistant::InlineAssist";

      # File navigation
      "space f f" = "file_finder::Toggle";
      "space f g" = "pane::DeploySearch";
      "space f t" = "task::Spawn";
      "space f b" = "tab_switcher::Toggle";
      "space f p" = "projects::OpenRecent";
      "space e" = "workspace::ToggleLeftDock";

      # Pane navigation
      "ctrl-h" = "workspace::ActivatePaneLeft";
      "ctrl-l" = "workspace::ActivatePaneRight";
      "ctrl-k" = "workspace::ActivatePaneUp";
      "ctrl-j" = "workspace::ActivatePaneDown";

      # Clipboard
      "ctrl-c" = "editor::Copy";
      "ctrl-v" = "editor::Paste";
      "ctrl-x" = "editor::Cut";
      "ctrl-a" = "editor::SelectAll";

      # Git operations
      "space g p" = "editor::ToggleSelectedDiffHunks";
      "space g b" = "git::Blame";
      "space g r" = "git::Restore";
      "space g i" = "editor::OpenGitBlameCommit";
      "space g c" = "editor::BlameHover";
      "space g w" = "git::Branch";

      # LSP navigation
      "g d" = "editor::GoToDefinition";
      "g D" = "editor::GoToDeclaration";
      "g I" = "editor::GoToImplementation";
      "g t" = "editor::GoToTypeDefinition";
      "g r" = "editor::FindAllReferences";

      # Terminal
      "space t n" = "terminal_panel::ToggleFocus";

      # Task spawning
      "space g g" = [
        "task::Spawn"
        {
          task_name = "Lazygit";
          reveal_target = "center";
        }
      ];
      "space l d" = [
        "task::Spawn"
        {
          task_name = "Lazydocker";
          reveal_target = "center";
        }
      ];
      "space g l" = [
        "task::Spawn"
        {
          task_name = "Git Log";
          reveal_target = "center";
        }
      ];
      "space t t" = [
        "task::Spawn"
        {
          task_name = "Tmux";
          reveal_target = "center";
        }
      ];
    };
  }

  # Visual mode
  {
    context = "vim_mode == visual && !menu";
    bindings = {
      "shift-j" = "editor::MoveLineDown";
      "shift-k" = "editor::MoveLineUp";
      "shift-tab" = "editor::Backtab";
      "tab" = "editor::Tab";
      "ctrl-c" = "editor::Copy";
      "ctrl-v" = "editor::Paste";
      "ctrl-x" = "editor::Cut";
    };
  }

  # Normal mode
  {
    context = "vim_mode == normal && !menu";
    bindings = {
      "shift-y" = [
        "workspace::SendKeystrokes"
        "y $"
      ];
      "tab" = "pane::ActivateNextItem";
      "shift-tab" = "pane::ActivatePreviousItem";
      "ctrl-c" = "editor::Copy";
      "ctrl-v" = "editor::Paste";
      "ctrl-x" = "editor::Cut";
      "ctrl-a" = "editor::SelectAll";
      "escape" = "workspace::Save";
    };
  }

  # Insert mode
  {
    context = "vim_mode == insert";
    bindings = {
      "escape" = [
        "workspace::SendKeystrokes"
        "ctrl-c ctrl-s"
      ];
      "ctrl-v" = "editor::Paste";
      "ctrl-j" = null;
      "ctrl-k" = null;
    };
  }

  # Empty pane or shared screen
  {
    context = "EmptyPane || SharedScreen";
    bindings = {
      "space f f" = "file_finder::Toggle";
      "space f g" = "pane::DeploySearch";
      "space f p" = "projects::OpenRecent";
      "space e" = "workspace::ToggleLeftDock";
      "space b d" = "pane::CloseActiveItem";
      "space q a" = "zed::Quit";
      "ctrl-c" = "editor::Copy";
      "ctrl-v" = "editor::Paste";
      "ctrl-x" = "editor::Cut";
      "ctrl-a" = "editor::SelectAll";
      "ctrl-h" = "workspace::ActivatePaneLeft";
      "ctrl-l" = "workspace::ActivatePaneRight";
      "ctrl-k" = "workspace::ActivatePaneUp";
      "ctrl-j" = "workspace::ActivatePaneDown";
      "space c c" = "workspace::ToggleRightDock";
      "space t n" = "terminal_panel::ToggleFocus";

      "space g g" = [
        "task::Spawn"
        {
          task_name = "Lazygit";
          reveal_target = "center";
        }
      ];
      "space l d" = [
        "task::Spawn"
        {
          task_name = "Lazydocker";
          reveal_target = "center";
        }
      ];
      "space g l" = [
        "task::Spawn"
        {
          task_name = "Git Log";
          reveal_target = "center";
        }
      ];
      "space t t" = [
        "task::Spawn"
        {
          task_name = "Tmux";
          reveal_target = "center";
        }
      ];
    };
  }

  # Project panel
  {
    context = "ProjectPanel && not_editing";
    bindings = {
      "a" = "project_panel::NewFile";
      "A" = "project_panel::NewDirectory";
      "r" = "project_panel::Rename";
      "d" = "project_panel::Delete";
      "x" = "project_panel::Cut";
      "c" = "project_panel::Copy";
      "p" = "project_panel::Paste";

      "q" = "workspace::ToggleLeftDock";
      "space e" = "workspace::ToggleLeftDock";
      "space c c" = "workspace::ToggleRightDock";

      "ctrl-h" = "workspace::ActivatePaneLeft";
      "ctrl-l" = "workspace::ActivatePaneRight";
      "ctrl-k" = "workspace::ActivatePaneUp";
      "ctrl-j" = "workspace::ActivatePaneDown";

      "space g g" = [
        "task::Spawn"
        {
          task_name = "Lazygit";
          reveal_target = "center";
        }
      ];
    };
  }

  # Dock
  {
    context = "Dock";
    bindings = {
      "ctrl-h" = "workspace::ActivatePaneLeft";
      "ctrl-l" = "workspace::ActivatePaneRight";
      "ctrl-k" = "workspace::ActivatePaneUp";
      "ctrl-j" = "workspace::ActivatePaneDown";
      "ctrl-x" = "workspace::ToggleBottomDock";
    };
  }

  # Code actions and completions
  {
    context = "Editor && (showing_code_actions || showing_completions)";
    bindings = {
      "ctrl-k" = "editor::ContextMenuPrevious";
      "ctrl-j" = "editor::ContextMenuNext";
    };
  }

  # Debug panel
  {
    context = "DebugPanel";
    bindings = {
      "escape" = "workspace::CloseActiveDock";
    };
  }

  # Terminal
  {
    context = "Terminal";
    bindings = {
      "escape" = "workspace::CloseActiveDock";
    };
  }
]
