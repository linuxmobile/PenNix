{ pkgs, packageSets }:

let
  allPackages = pkgs.lib.flatten (builtins.attrValues packageSets);
  # Expose category shells for each set
  categoryShells = pkgs.lib.mapAttrs (name: pkgsList: pkgs.mkShell {
    name = name;
    packages = pkgsList;
  }) packageSets;
in
categoryShells // {
  default = pkgs.mkShell {
    name = "default";
    packages = allPackages;
  };
}
