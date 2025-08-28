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
  ];

  boot.isContainer = true;

  environment = {
    shellInit = ''
      # Ensure Home Manager profile is in PATH
      export PATH="$HOME/.nix-profile/bin:$PATH"

      # Fix ghostty TERM for compatibility
      if [ "$TERM" = "xterm-ghostty" ]; then
        export TERM="xterm-256color"
      fi
    '';
  };

  environment.systemPackages = with pkgs; [
    nushell
    starship
    carapace
  ];

  users.users.root.shell = pkgs.nushell;

  environment.etc."root/.config/nushell/config.nu".text = ''
    $env.STARSHIP_CONFIG = "/root/.config/starship.toml"
    $env.STARSHIP_SHELL = "nu"
    source /root/.local/share/nushell/vendor/autoload/starship.nu
  '';

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

  system.activationScripts.nushell-config = ''
    /run/current-system/sw/bin/mkdir -p /root/.config/nushell
    /run/current-system/sw/bin/cp -f /etc/root/.config/nushell/config.nu /root/.config/nushell/config.nu
  '';

  system.activationScripts.nushell-starship = ''
    /run/current-system/sw/bin/mkdir -p /root/.local/share/nushell/vendor/autoload
    /run/current-system/sw/bin/starship init nu | /run/current-system/sw/bin/tee /root/.local/share/nushell/vendor/autoload/starship.nu > /dev/null
  '';

  # users
  users.users.pennix = {
    isNormalUser = true;
    uid = 1000;
    description = "Pennix container user";
    password = "pennix";
    extraGroups = ["wheel"];
  };
}
