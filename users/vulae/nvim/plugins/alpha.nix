{ lib, ... }: {
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
            {
              type = "button";
              val = "  New file";
              on_press.__raw = "function() vim.cmd[[ene]] end";
              opts = { shortcut = "e"; position = "center"; cursor = 3; width = 40; align_shortcut = "right"; hl_shortcut = "Keyword"; };
            }
            {
              type = "button";
              val = "󰈞  Find files";
              opts = { shortcut = "<leader> s f"; position = "center"; cursor = 3; width = 40; align_shortcut = "right"; hl_shortcut = "Keyword"; };
            }
            {
              type = "button";
              val = "󰊄  Live grep";
              opts = { shortcut = "<leader> s g"; position = "center"; cursor = 3; width = 40; align_shortcut = "right"; hl_shortcut = "Keyword"; };
            }
            {
              type = "button";
              val = "  Search TODOs";
              opts = { shortcut = "<leader> s t"; position = "center"; cursor = 3; width = 40; align_shortcut = "right"; hl_shortcut = "Keyword"; };
            }
            {
              type = "button";
              val = "󰅚  Quit Neovim";
              on_press.__raw = "function() vim.cmd[[qa]] end";
              opts = { shortcut = "q"; position = "center"; cursor = 3; width = 40; align_shortcut = "right"; hl_shortcut = "Keyword"; };
            }
          ];
        }
        { type = "padding"; val = 2; }
        {
          type = "text";
          val.__raw = ''
            (function()
              local list = {${toString (
                let
                  content = builtins.readFile ../../kaomoji.txt;
                  lines = builtins.filter (x: !(builtins.typeOf x != "string" || x == "")) (builtins.split "\n" content);
                  filtered = builtins.filter (line: !(lib.hasPrefix "###" line)) lines;
                  escaped = map (line: "\"${builtins.replaceStrings ["\""] ["\\\""] line}\"") filtered;
                in builtins.concatStringsSep "," escaped
              )}}
              return list[math.random(#list)] or "Something went very, very wrong."
            end)()
          '';
          opts = { position = "center"; hl = "Keyword"; };
        }
      ];
    };
  };
}
