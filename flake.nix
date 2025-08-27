{
  description = "Pennix: a NixOS Pentesting Container";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    supportedSystems = ["x86_64-linux"];
    genSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = genSystems (system:
      import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowInsecurePredicate = p: true;
          segger-jlink.acceptLicense = true;
        };
      });

    pkgsFiles = [
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

    # Helper to extract environment.systemPackages from each module
    getPackageSets = pkgs:
      builtins.listToAttrs (map (
          file: let
            name = builtins.baseNameOf (toString file);
            name' = builtins.replaceStrings [".nix"] [""] name;
            mod = import file {inherit pkgs;};
            pkgsList = mod.environment.systemPackages or [];
          in {
            name = name';
            value = pkgsList;
          }
        )
        pkgsFiles);
  in {
    devShells = genSystems (
      system:
        import ./shells {
          pkgs = pkgs.${system};
          packageSets = getPackageSets pkgs.${system};
        }
    );

    packages = genSystems (
      system: let
        sets = getPackageSets pkgs.${system};
        allPkgs = pkgs.${system}.lib.flatten (builtins.attrValues sets);
      in
        builtins.listToAttrs (map (pkg: {
            name = pkg.pname or pkg.name or "unknown";
            value = pkg;
          })
          allPkgs)
    );

    nixosConfigurations = genSystems (
      system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs;};
          modules = [./container-config.nix];
        }
    );

    container = ./container.nix;
  };
}
