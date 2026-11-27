{
  neovim.mods =
    { pkgs, ... }:
    {
      plugins = {
        conform-nvim.settings = {
          formatters_by_ft.go = [ "gofmt" ];
        };
        lsp.servers.golangci_lint_ls = {
          enable = false;
          package = pkgs.golangci-lint-langserver;
        };
        lsp.servers.gopls = {
          enable = false;
          package = pkgs.gopls;
          filetypes = [
            "go"
            "gomod"
            "gowork"
          ];
        };
      };
      extraPackages = with pkgs; [
        golangci-lint
      ];
    };
}
