self: super:
let
  inherit (super.vimUtils) buildVimPluginFrom2Nix;
in
{
  vimPlugins = super.vimPlugins // {
    vim-nerdtree-syntax-highlight = buildVimPluginFrom2Nix {
      pname = "vim-nerdtree-syntax-highlight";
      version = "2020-07-19";
      src = super.fetchFromGitHub {
        owner = "tiagofumo";
        repo = "vim-nerdtree-syntax-highlight";
        rev = "1acc12aa7f773ede38538293332905f1ba3fea6a";
        sha256 = "0zm023mhi1si9g5r46md1v4rlls6z2m6kyn1jcfxjqyrgba67899";
      };
      meta.homepage = "https://github.com/tiagofumo/vim-nerdtree-syntax-highlight/";
    };

    nerdtree-git-plugin = buildVimPluginFrom2Nix {
      pname = "nerdtree-git-plugin";
      version = "2020-09-11";
      src = super.fetchFromGitHub {
        owner = "Xuyuanp";
        repo = "nerdtree-git-plugin";
        rev = "a8c031f11dd312f53357729ca47ad493e798aa86";
        sha256 = "1d64cmywhj43q9fkrh0kcfsxa7ijxcb1fbz38pxaacg082y6l0jy";
      };
      meta.homepage = "https://github.com/Xuyuanp/nerdtree-git-plugin/";
    };

    scrollbar-nvim = buildVimPluginFrom2Nix {
      pname = "scrollbar-nvim";
      version = "2020-09-21";
      src = super.fetchFromGitHub {
        owner = "Xuyuanp";
        repo = "scrollbar.nvim";
        rev = "f032f340385a784184860a4a6e12f9f6a055b5f8";
        sha256 = "1jcwvawq53lmlqqbvqhnphvam9lrlxqnphr7ww2ywxxpk0ald9bb";
      };
      meta.homepage = "https://github.com/Xuyuanp/scrollbar.nvim/";
    };

    neoformat = buildVimPluginFrom2Nix {
      pname = "neoformat";
      version = "2020-09-21";

      src = super.fetchFromGitHub {
        owner = "zachcoyle";
        repo = "neoformat";
        rev = "efaee6886c963cf495c88916acb49232355e1f6f";
        sha256 = "1sp5ld4dk7bi9ym0x2iyz5qmsiab5klgnccfamcpmzvsfwdjz413";
      };
      meta.homepage = "https://github.com/sbdchd/neoformat";
    };

  };
}
