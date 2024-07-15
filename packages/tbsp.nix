{
  lib,
  rustPlatform,
  fetchgit,
}:

rustPlatform.buildRustPackage rec {
  pname = "tbsp";
  version = "unstable";

  src = fetchgit {
    url = "https://git.peppe.rs/languages/tbsp";
    rev = "ba102d6162d046f7ed7b139355e81da0c9f89acb";
    hash = "sha256-QEOy/DVLg7O8g8uCtZqt09aeaGvQJ2LrC2jBRnCN880=";
  };

  cargoHash = "sha256-+zb4hOLVSTCuThm04pK9EbUvKdht9CoHHokDGeyM02M=";

  meta = with lib; {
    description = "";
    homepage = "https://git.peppe.rs/languages/tbsp";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [ ];
    mainProgram = "tbsp";
  };
}
