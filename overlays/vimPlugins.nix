self: super:
let
  inherit (super.vimUtils) buildVimPluginFrom2Nix;
in
{
  vimPlugins = super.vimPlugins // {
    nerdtree-git-plugin = buildVimPluginFrom2Nix {
      pname = "nerdtree-git-plugin";
      version = "2020-09-25";
      src = super.fetchFromGitHub {
        owner = "Xuyuanp";
        repo = "nerdtree-git-plugin";
        rev = "85c4bed898d2d755a2a2ffbfc2433084ce107cdd";
        sha256 = "RJk9eYlW5Avyv7lkmYS/skB2B17b/uVEQOWgCUYvGtU=";
      };
      meta.homepage = "https://github.com/Xuyuanp/nerdtree-git-plugin/";
    };

    scrollbar-nvim = buildVimPluginFrom2Nix {
      pname = "scrollbar-nvim";
      version = "2020-09-28";
      src = super.fetchFromGitHub {
        owner = "Xuyuanp";
        repo = "scrollbar.nvim";
        rev = "72a4174a47a89b7f89401fc66de0df95580fa48c";
        sha256 = "Pmn1RHCYf3Ty0mL+5PshIXsF5heLb2TB2YT9VS85c4I=";
      };
      meta.homepage = "https://github.com/Xuyuanp/scrollbar.nvim/";
    };

    vim-ripgrep = buildVimPluginFrom2Nix {
      pname = "vim-ripgrep";
      version = "2018-09-08";
      src = super.fetchFromGitHub {
        owner = "jremmen";
        repo = "vim-ripgrep";
        rev = "ec87af6b69387abb3c4449ce8c4040d2d00d745e";
        sha256 = "sFp57KGnMu3a7pTNPx3vNfuPhMhJqc22tHWBTF02xa8=";
      };
    };
  };
}
