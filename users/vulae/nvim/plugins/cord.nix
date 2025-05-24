{ ... }: {
  programs.nixvim = {
    plugins.cord = {
      enable = true;
      luaConfig.pre = ''
        local function is_subpath(parent, child)
          parent = vim.fn.fnamemodify(parent, ":p")
          child = vim.fn.fnamemodify(child, ":p")
          parent = parent:gsub("/$", "")
          child = child:gsub("/$", "")
          return vim.startswith(child, parent)
        end

        local function cord_is_whitelist(opts)
          if opts.type == "docs" then
            return true
          end

          local whitelist = {
            "~/repos/",
          }

          for _, whitelist_path in ipairs(whitelist) do
            if is_subpath(whitelist_path, opts.workspace_dir) then
              return true
            end
          end

          return false
        end
      '';
      settings = {
        hooks = {
          post_activity.__raw = ''
            function(opts, activity)
              if not cord_is_whitelist(opts) then
                opts.manager:skip_update()
              end
            end
          '';
        };
      };
    };
  };
}
