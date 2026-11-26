{
  inputs,
  config,
  lib,
  ...
}:
{
  config = {
    tack.inputs = {
      nixpkgs.url = "gh:nixos/nixpkgs/nixos-unstable";
      nixvim.url = "gh:nix-community/nixvim";
      neovim.url = "gh:nix-community/neovim-nightly-overlay";
    };
    perSystem =
      { pkgs, inputs', ... }:
      {
        packages =
          lib.genAttrs [ "light" "dark" "monochrome" ] (
            theme:
            (inputs.nixvim.lib.evalNixvim {
              extraSpecialArgs = {
                inherit inputs;
                inherit (inputs.nixvim.lib.nixvim) mkRaw;
              };
              modules = with config.neovim; [
                core
                mods
                visual
                {
                  package = inputs'.neovim.packages.default;
                  nixpkgs = { inherit pkgs; };
                  nito = { inherit theme; };
                }
              ];
            }).config.build.package
          )
          // {
            neovim = inputs'.neovim.packages.default;
          };
      };
  };
  options = {
    perSystem = lib.mkOption { type = lib.types.deferredModule; };
    systems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "x86_64-linux" ];
    };
    neovim = {
      mods = lib.mkOption {
        type = lib.types.deferredModule;
      };
      visual = lib.mkOption {
        type = lib.types.deferredModule;
      };
      core = lib.mkOption {
        type = lib.types.deferredModule;
      };
    };
  };
}
