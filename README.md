Uses [home-manager](https://github.com/nix-community/home-manager) for most configuration and [nix-darwin](https://github.com/LnL7/nix-darwin) for macOS-specific config

`./scripts/generate_machine.sh` will generate a machine.nix file with some machine-specific info

`./env.nix` is untracked and just contains environment variables:

```nix
{ programs, ... }:
{
  programs.zsh.sessionVariables = {
    FOO = "BAR";
  };
}
```
