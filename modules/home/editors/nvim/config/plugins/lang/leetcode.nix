_: {
  plugins.leetcode = {
    enable = true;
    settings = {
      lang = "golang";

      image_support = true;

      picker = {
        provider = "telescope";
      };

      injector = {
        golang = {
          before = [ "package main" ];
        };
      };

      description = {
        show = true;
        position = "left";
      };
    };
  };
}
