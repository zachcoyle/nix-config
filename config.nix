{
  allowUnfree = true;
  android_sdk.accept_license = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseAudio.support32Bit = true;

  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
}
