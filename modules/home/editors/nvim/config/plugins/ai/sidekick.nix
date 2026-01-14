{
  plugins.sidekick = {
    enable = true;
    settings = {
      cli = {
        mux = {
          backend = "tmux";
          enabled = true;
        };
      };
    };
  };

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cc";
      action.__raw = ''
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end
      '';
      options = {
        desc = "Sidekick Copilot Toggle";
        silent = true;
      };
    }
    {
      mode = [ "n" ];
      key = "<tab>";
      action.__raw = ''
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end
      '';
      options = {
        desc = "Goto/Apply Next Edit Suggestion";
        expr = true;
        silent = true;
      };
    }
  ];
}
