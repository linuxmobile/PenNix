# Port scanners
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # das isn't building
    havn
    ipscan
    masscan
    naabu
    nmap
    udpx
    smap
    sx-go
    rustscan
    zmap
  ];
}
