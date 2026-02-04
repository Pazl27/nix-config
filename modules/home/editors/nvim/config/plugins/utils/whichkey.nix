{
  plugins.which-key = {
    enable = true;
    settings = {
      spec = [
        {
          __unkeyed-1 = "<leader>f";
          mode = "n";
          group = "Telescope";
          icon = "󱡁";
        }
        {
          __unkeyed-1 = "<leader>d";
          mode = [
            "n"
          ];
          group = "Debug";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>b";
          mode = [
            "n"
          ];
          group = "Buffer";
        }
        {
          __unkeyed-1 = "<leader>s";
          mode = [
            "n"
          ];
          group = "Split|Search";
        }
        {
          __unkeyed-1 = "<leader>x";
          mode = [
            "n"
          ];
          group = "Trouble";
        }
        {
          __unkeyed-1 = "<leader>g";
          mode = [
            "n"
          ];
          group = "Git";
        }
        {
          __unkeyed-1 = "<leader>q";
          mode = "n";
          group = "+quit/session";
        }
        {
          __unkeyed-1 = "<leader>t";
          mode = "n";
          group = "Test";
        }
        {
          __unkeyed-1 = "<leader>m";
          mode = "n";
          group = "Markdown";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>r";
          mode = "n";
          group = "Rename";
        }
        {
          __unkeyed-1 = "<leader>c";
          mode = "n";
          group = "Copilot";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>go";
          mode = "n";
          group = "Go";
          icon = "󰟓";
        }

      ];
    };
  };
}
