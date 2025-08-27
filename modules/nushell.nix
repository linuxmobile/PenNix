{ config, pkgs, ... }:
{
  programs.nushell.enable = true;
  # Optionally, add custom Nushell config here
  # programs.nushell.configFile.source = ./nushell-config.nu;
}
