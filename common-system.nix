{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  home-manager.backupFileExtension = "backup";
}
