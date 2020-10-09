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

    yanil = buildVimPluginFrom2Nix {
      pname = "yanil";
      version = "2020-10-09";
      src = super.fetchFromGitHub {
        owner = "Xuyuanp";
        repo = "yanil";
        rev = "b070337cd5b5488fa55444e62f285a2af8b0d321";
        sha256 = "FlXoU9Xnk/kpsgK5gPkXRms1tayrNlZcmDXuh9hdYX0=";
      };
    };
  };
}
