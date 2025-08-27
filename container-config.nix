{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./pkgs/bluetooth.nix
    ./pkgs/cloud.nix
    ./pkgs/code.nix
    ./pkgs/container.nix
    ./pkgs/dns.nix
    ./pkgs/exploits.nix
    ./pkgs/forensics.nix
    ./pkgs/fuzzers.nix
    ./pkgs/generic.nix
    ./pkgs/hardware.nix
    ./pkgs/host.nix
    ./pkgs/information-gathering.nix
    ./pkgs/kubernetes.nix
    ./pkgs/ldap.nix
    ./pkgs/load-testing.nix
    ./pkgs/malware.nix
    ./pkgs/misc.nix
    ./pkgs/mobile.nix
    ./pkgs/network.nix
    ./pkgs/packet-generators.nix
    ./pkgs/password.nix
    ./pkgs/port-scanners.nix
    ./pkgs/proxies.nix
    ./pkgs/services.nix
    ./pkgs/smartcards.nix
    ./pkgs/terminals.nix
    ./pkgs/tls.nix
    ./pkgs/traffic.nix
    ./pkgs/tunneling.nix
    ./pkgs/voip.nix
    ./pkgs/web.nix
    ./pkgs/windows.nix
    ./pkgs/wireless.nix
    ./modules/starship.nix
    ./modules/nushell.nix
    ./modules/carapace.nix
  ];

  boot.isContainer = true;

  environment = {
    # shellInit = "export DISPLAY=${get-host-ip}:0"; # (check later)
  };

  networking = {
    nat = {
      enable = true;
      internalInterfaces = ["ve-pennix"];
      externalInterface = "eth0";
    };
    useDHCP = false;
    hostName = "Pennix";
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [];
    };
  };

  # nix config
  nix = {
    settings.extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # nixpkgs config
  nixpkgs.config = {
    allowUnfree = true;
    allowInsecurePredicate = p: true;
    segger-jlink.acceptLicense = true;
  };

  # services
  services = {
    getty.autologinUser = "pennix";

    openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };

    avahi = {
      enable = true;
      browseDomains = [];
      wideArea = false;
      nssmdns4 = true;
    };

    unbound = {
      enable = true;
      settings.server = {};
    };
  };

  system.stateVersion = "24.05";

  # users
  users.users.pennix = {
    isNormalUser = true;
    uid = 1000;
    description = "Pennix container user";
    password = "pennix";
    extraGroups = ["wheel"];
  };
}
