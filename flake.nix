{
  description = "The new terranix.org — Hugo static site with the terratheme theme.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./nix/treefmt.nix
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          theme = pkgs.callPackage ./nix/theme.nix { };
          site = pkgs.callPackage ./nix/default.nix { };
          shell = pkgs.callPackage ./nix/shell.nix { };
        in
        {
          devShells.default = shell;
          packages = {
            theme = theme;
            site = site;
            default = site;
          };
        };
    };
}
