{lib, ...}: let
  get-host-ip = "$(ip route | grep default | cut -d' ' -f3)";
in {
  imports = [
    ./modules/nushell.nix
    ./modules/starship.nix
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
  ];

  boot.isContainer = true;

  environment = {
    shellInit = ''
      export DISPLAY=${get-host-ip}:0
      # Ensure Home Manager profile is in PATH
      export PATH="$HOME/.nix-profile/bin:$PATH"

      # Fix ghostty TERM for compatibility
      if [ "$TERM" = "xterm-ghostty" ]; then
        export TERM="xterm-256color"
      fi
    '';
  };

  networking = {
    useHostResolvConf = lib.mkForce false;
    nat = {
      enable = true;
      internalInterfaces = ["ve-pennix"];
      externalInterface = "eth0";
    };
    useDHCP = false;
    hostName = "PenNix";
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [];
    };
  };

  nix = {
    settings.extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowInsecurePredicate = true;
    segger-jlink.acceptLicense = true;
  };

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

  users.users.pennix = {
    isNormalUser = true;
    uid = 1000;
    description = "Pennix container user";
    password = "pennix";
    extraGroups = ["wheel"];
  };
}
