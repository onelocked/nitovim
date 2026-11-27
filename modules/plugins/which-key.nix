{
  neovim.mods = { pkgs, ... }: {
    plugins = {
      which-key = {
        enable = true;
        settings = {
          preset = "helix";
          win.border = "single";
        };
      };
      tmux-navigator.enable = false;
      web-devicons = {
        enable = true;
        package = pkgs.vimPlugins.nvim-web-devicons.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace lua/nvim-web-devicons.lua \
              --replace-fail 'vim.F.if_nil' 'vim.nonnil'
          '';
        });
      };
      lz-n.enable = true;
    };
  };
}
