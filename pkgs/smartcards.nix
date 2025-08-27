# Smartcard tools
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cardpeek
    libfreefare
    mfcuk
    mfoc
    # python314Packages.emv (check later)
  ];
}
