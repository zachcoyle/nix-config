{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "airdrop-cli";
  version = "d30aa82";

  src = fetchFromGitHub {
    owner = "kabiroberai";
    repo = "airdrop-cli";
    rev = "d30aa826c59760391b1f092e00300406b049137a";
    sha256 = "14lwlf2sxfpi2c7xhjmijcnda2nb7wykcggx6bchcv3my4wqr8xk";
  };

  buildPhase = ''
    chmod +x airdrop.applescript
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp airdrop.applescript $out/bin/airdrop
  '';
}
