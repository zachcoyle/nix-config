{ programs, ... }:

{
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "fmkadmapgofadopljbjfkapdkoienihi" # react devtools
      "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
      "bappiabcodbpphnojdiaddhnilfnjmpm" # hackernews enhancement suite
    ];
  };

  programs.firefox = {
    enable = true;
  };

}
