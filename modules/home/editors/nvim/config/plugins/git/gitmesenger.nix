{ pkgs, ... }:
{
  plugins.gitmessenger = {
    enable = true;
    autoLoad = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>GitMessenger<CR>";
      options = {
        desc = "View Commit";
      };
    }
  ];
}
