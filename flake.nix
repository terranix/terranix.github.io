{
  description = "terranix.org website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          mdbookRuntimeInputs = [
            pkgs.mdbook
            pkgs.mdbook-linkcheck
          ];
          treefmtRuntimeInputs = [
            pkgs.treefmt
            pkgs.nixpkgs-fmt
            pkgs.shfmt
            pkgs.shellcheck
            pkgs.black
            pkgs.nodePackages.prettier
          ];
        in
        {
          apps = rec {
            default = serve;
            serve.program = pkgs.writeShellApplication {
              name = "serve";
              runtimeInputs = mdbookRuntimeInputs;
              text = "mdbook serve";
            };
            check.program = pkgs.writeShellApplication {
              name = "check";
              runtimeInputs = treefmtRuntimeInputs ++ mdbookRuntimeInputs;
              text = ''
                treefmt --no-cache --fail-on-change
                mdbook build
              '';
            };
          };
          formatter = pkgs.writeShellApplication {
            name = "treefmt";
            runtimeInputs = treefmtRuntimeInputs;
            text = ''treefmt "$@"'';
          };
        };
      flake = { };
    };
}
