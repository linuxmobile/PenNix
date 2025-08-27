# Password and hashing tools
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    authoscope
    bruteforce-luks
    brutespray
    conpass
    crunch
    h8mail
    hashcat
    hashcat-utils
    hashdeep
    john
    legba
    medusa
    nasty
    ncrack
    nth
    phrasendrescher
    # python314Packages.patator (don't build)
    thc-hydra
    truecrack
  ];
}
