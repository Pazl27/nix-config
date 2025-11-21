{
  plugins.sidekick = {
    enable = true;

    # Equivalent to your Lua opts
    settings = {
      cli = {
        mux = {
          backend = "tmux";
          enabled = true;
        };
      };
    };
  };

  # Key mappings
  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>cc";
      action = ''
        function()
          require("sidekick.cli").toggle({ name = "copilot", focus = true })
        end
      '';
      lua = true;
      desc = "Sidekick Copilot Toggle";
    }
    {
      mode = [ "n" ];
      key = "<tab>";
      action = ''
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end
      '';
      lua = true;
      expr = true;
      desc = "Goto/Apply Next Edit Suggestion";
    }
  ];
}
