# Bluetooth tools
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bluez
    bluewalker
    # python314Packages.bleak (check later)
    redfang
    ubertooth
  ];
}
