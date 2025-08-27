{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ carapace ];

  # Enable completions for supported shells
  programs.bash.interactiveShellInit = ''
    eval "$(carapace _carapace bash)"
  '';
  programs.zsh.interactiveShellInit = ''
    eval "$(carapace _carapace zsh)"
  '';
  programs.fish.interactiveShellInit = ''
    carapace _carapace fish | source
  '';
  programs.nushell.extraConfig = ''
    carapace _carapace nushell | save --force ~/.cache/carapace.nu
    source ~/.cache/carapace.nu
  '';
}
