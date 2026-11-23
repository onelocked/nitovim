{
  neovim.mods =
    { mkRaw, ... }:
    {
      plugins.blink-pairs = {
        enable = true;
        lazyLoad.settings.event = [
          "BufReadPost"
          "BufNewFile"
        ];
        settings.highlights.groups = [
          "BlinkPairsRed"
          "BlinkPairsYellow"
          "BlinkPairsBlue"
          "BlinkPairsOrange"
          "BlinkPairsGreen"
          "BlinkPairsPurple"
          "BlinkPairsCyan"
        ];
      };

      autoCmd = [
        {
          event = [ "FileType" ];
          pattern = "nix";
          callback =
            # lua
            mkRaw ''
              function(args)
                vim.keymap.set('i', "'", function()
                  local q = "'"
                  local col = vim.api.nvim_win_get_cursor(0)[2]
                  if col >= 2 and vim.api.nvim_get_current_line():sub(col - 1, col) == q .. q then
                    return "\n\n" .. q .. q .. "<Up>"
                  end
                  return q
                end, { buffer = args.buf, expr = true, desc = "Nix multiline string" })
              end
            '';
        }
      ];
    };
}
