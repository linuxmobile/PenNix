{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    # Optionally, add custom settings here
    # settings = {
    #   add_newline = false;
    # };
  };
}
