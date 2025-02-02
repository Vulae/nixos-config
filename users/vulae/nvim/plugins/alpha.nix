{
  programs.nixvim = {
    plugins.alpha = {
      enable = true;
      layout = [
        { type = "padding"; val = 8; }
        # 🏳️‍⚧️
        {
          type = "group";
          val.__raw = ''
            (function()
              local width = 35
              local height = 10

              local char = "█"
              local char_width = 3

              local val = {}
              for j = 1, height do
                val[j] = string.rep(char, width)
              end

              vim.api.nvim_set_hl(0, "FlagTrans0", { fg = "#5bcefa" })
              vim.api.nvim_set_hl(0, "FlagTrans1", { fg = "#f5a9b8" })
              vim.api.nvim_set_hl(0, "FlagTrans2", { fg = "#ffffff" })

              local hl = {}
              for j = 1, height do
                local indices = { 0, 1, 2, 1, 0 }
                local col_index = indices[math.floor((j - 1) / height * #indices) + 1]
                hl[j] = { { "FlagTrans" .. col_index, 0, width * char_width } }
              end

              return {{
                type = "text",
                val = val,
                opts = {
                  hl = hl,
                  position = "center",
                },
              }}
            end)()
          '';
        }
        { type = "padding"; val = 2; }
        {
          type = "group";
          val = [
            {
              type = "text";
              val = "Quick links";
              opts = { position = "center"; hl = "SpecialComment"; };
            }
            {
              type = "padding";
              val = 1;
            }
            # TODO: Fix all buttons being not aligned.
            {
              type = "button";
              val = "  New file";
              on_press.__raw = "function() vim.cmd[[ene]] end";
              opts = { position = "center"; shortcut = "n"; };
            }
            {
              type = "button";
              val = "󰈞  Find files";
              opts = { position = "center"; shortcut = "<leader> s f"; };
            }
            {
              type = "button";
              val = "󰊄  Live grep";
              opts = { position = "center"; shortcut = "<leader> s g"; };
            }
            {
              type = "button";
              val = "  Search TODOs";
              opts = { position = "center"; shortcut = "<leader> s t"; };
            }
            {
              type = "button";
              val = "󰅚  Quit Neovim";
              on_press.__raw = "function() vim.cmd[[qa]] end";
              opts = { position = "center"; shortcut = "q"; };
            }
          ];
        }
        { type = "padding"; val = 2; }
        {
          type = "text";
          val = "meow";
          opts = { position = "center"; hl = "Keyword"; };
        }
      ];
    };
  };
}
