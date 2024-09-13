{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "lazyjj";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Cretezy";
    repo = "lazyjj";
    rev = "v${version}";
    hash = "sha256-VlGmOdF/XsrZ/9vQ14UuK96LIK8NIkPZk4G4mbS8brg=";
  };

  cargoHash = "sha256-TAq9FufGsNVsmqCE41REltYRSSLihWJwTMoj0bTxdFc=";

  doCheck = false;

  meta = {
    description = "TUI for Jujutsu/jj";
    homepage = "https://github.com/Cretezy/lazyjj";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [];
    mainProgram = "lazyjj";
  };
}
