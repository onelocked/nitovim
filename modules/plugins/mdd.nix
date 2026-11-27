{
  neovim.mods =
    { mkRaw, ... }:
    {
      extraConfigLua = # lua
        ''
          local mdd_panes = {}

          _G.mdd_preview = function()
            local file = vim.api.nvim_buf_get_name(0)
            if file == "" then
              return vim.notify("mdd: buffer has no file", vim.log.levels.WARN)
            end

            local id = mdd_panes[file]
            if
              id
              and vim.system({ "kitty", "@", "focus-window", "-m", "id:" .. id }):wait().code == 0
            then
              return
            end

            local res = vim.system({
              "kitty",
              "@",
              "launch",
              "--self", -- split nvim's tab, whatever tab is focused
              "--keep-focus",
              "--location=vsplit",
              "--bias=40",
              "--cwd=" .. vim.fs.dirname(file),
              "mdd",
              file,
            }, { text = true }):wait()
            if res.code ~= 0 then
              return vim.notify("mdd: " .. (res.stderr or "kitty launch failed"), vim.log.levels.ERROR)
            end
            mdd_panes[file] = tonumber(res.stdout)
          end

          -- Close the preview when its buffer leaves the current window.
          vim.api.nvim_create_autocmd("BufLeave", {
            callback = function(args)
              local file = vim.api.nvim_buf_get_name(args.buf)
              local id = mdd_panes[file]
              if not id then
                return
              end
              mdd_panes[file] = nil
              vim.fn.jobstart({ "kitty", "@", "close-window", "-m", "id:" .. id }, { detach = true })
            end,
          })

          -- Leave no stale pane behind when the editor quits.
          vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
              for _, id in pairs(mdd_panes) do
                vim.fn.jobstart({ "kitty", "@", "close-window", "-m", "id:" .. id }, { detach = true })
              end
            end,
          })
        '';

      keymaps = [
        {
          mode = "n";
          key = "<leader>m";
          action = mkRaw "function() mdd_preview() end";
          options = {
            desc = "Preview file with mdd (kitty split)";
            silent = true;
            noremap = true;
          };
        }
      ];
    };
}
