{
  tack.inputs.grug-far = {
    url = "gh:MagicDuck/grug-far.nvim";
    type = "fetch";
  };
  neovim.mods = { pkgs, inputs, ... }: {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        pname = inputs._meta.grug-far.repo;
        version = inputs._meta.grug-far.rev;
        src = inputs.grug-far;
      })
    ];
    extraConfigLua = ''
      require('grug-far').setup()
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>sr";
        action = "<cmd>GrugFar<CR>";
        options = {
          desc = "Search & Replace";
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>sr";
        action = "<cmd>GrugFar<CR>";
        options = {
          desc = "Search & Replace (selection)";
          silent = true;
        };
      }
    ];
  };
}
