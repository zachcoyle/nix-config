{ lib
, pkgs
, programs
, ...
}:
with pkgs;
{
  programs.home-manager.enable = true;

  programs.chromium = {
    enable = (system == "x86_64-linux");
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "fmkadmapgofadopljbjfkapdkoienihi" # react devtools
      "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
      "bappiabcodbpphnojdiaddhnilfnjmpm" # hackernews enhancement suite
    ];
  };

  programs.firefox = {
    enable = (system == "x86_64-linux");
  };


  programs.htop = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Zach Coyle";
    userEmail = "zach.coyle@gmail.com";
    package = gitAndTools.gitFull;
    delta = { enable = true; };
    extraConfig = {
      pull = { ff = "only"; };
      fetch = { prune = "true"; };
      commit = { gpgsign = "true"; };
    };
  };

  programs.gpg = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

}
