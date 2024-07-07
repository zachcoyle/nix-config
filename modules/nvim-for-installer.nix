{ pkgs, ... }:
{
  enable = true;
  enableMan = false;
  luaLoader.enable = true;
  extraPackages = with pkgs; [
    beautysh
    nixfmt-rfc-style
    stylua
  ];
  options = {
    mouse = "a";
    clipboard = "unnamedplus";
    number = true;
    relativeNumber = true;
    wrap = false;
  };
  globals.mapleader = " ";
  plugins = {
    cmp-nvim-lsp.enable = true;
  };
}
