# Tools to generate packets
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    boofuzz
    gping
    fping
    hping
    ostinato
    pktgen
    # python314Packages.scapy (check later)
  ];
}
