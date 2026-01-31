{
  plugins = {
    # Breadcrumbs at top
    barbecue = {
      enable = true;
      settings = {
        show_dirname = false;
        show_basename = true;
      };
    };

    # Required for barbecue to get code context
    navic = {
      enable = true;
      settings = {
        lsp.auto_attach = true;
      };
    };
  };
}
