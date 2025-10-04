{
  programs.nixvim = {
    plugins.nvim-tree = {
      enable = true;
      # FIXME: Open on setup doesn't work???
      openOnSetup = true;
    };
    keymaps = [
      {
        key = "<leader>nt";
        mode = "n";
        action = "<cmd>:NvimTreeOpen<CR>";
        options = {
          desc = "Open [N]vim[T]ree";
        };
      }
    ];
  };
}
