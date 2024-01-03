{
  description = "terranix.org website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        apps = {
          default.program = pkgs.writeShellApplication {
            name = "serve";
            runtimeInputs = [ pkgs.mdbook ];
            text = "mdbook serve";
          };
        };
        formatter =
          pkgs.writeShellApplication {
            name = "treefmt";
            runtimeInputs = [
              pkgs.treefmt
              pkgs.nixpkgs-fmt
              pkgs.shfmt
              pkgs.shellcheck
              pkgs.black
              pkgs.nodePackages.prettier
            ];
            text = "treefmt";
          };
      };
      flake = { };
    };
}
