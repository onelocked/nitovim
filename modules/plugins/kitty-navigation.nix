{
  neovim.mods = {
    extraConfigLua = # lua
      ''
        -- <C-w>h/j/k/l: nvim splits first, then kitty splits.
        local kitty_dirs = { h = "left", j = "bottom", k = "top", l = "right" }
        local function kitty_focus(dir)
          if vim.env.KITTY_LISTEN_ON == nil then
            return
          end
          vim.system({ "kitty", "@", "focus-window", "--match=neighbor:" .. dir }):wait()
        end
        for key, dir in pairs(kitty_dirs) do
          vim.keymap.set("n", "<C-w>" .. key, function()
            local win = vim.api.nvim_get_current_win()
            vim.cmd("wincmd " .. key)
            if vim.api.nvim_get_current_win() == win then
              kitty_focus(dir)
            end
          end, { desc = "Move " .. dir .. " (nvim split, then kitty split)" })
        end
      '';
  };
}
