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
          allowInsecurePredicate = true;
          segger-jlink.acceptLicense = true;
        };
      });

    # Helper to extract environment.systemPackages from each package set
    getPackageSets = pkgsSet:
      builtins.mapAttrs (_: v: v.environment.systemPackages or []) pkgsSet;
  in {
    devShells = genSystems (
      system:
        import ./shells {
          pkgs = pkgs.${system};
          packageSets = getPackageSets (import ./pkgs {pkgs = pkgs.${system};});
        }
    );

    packages = genSystems (
      system: let
        sets = getPackageSets (import ./pkgs {pkgs = pkgs.${system};});
        allPkgs = pkgs.${system}.lib.flatten (builtins.attrValues sets);
      in
        builtins.listToAttrs (map (pkg: {
            name = pkg.pname or pkg.name or "unknown";
            value = pkg;
          })
          allPkgs)
    );

    nixosConfigurations = {
      pennix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [./container-config.nix];
      };
    };

    container = ./container.nix;
  };
}
