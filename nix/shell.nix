{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShellNoCC {
  packages = [
    pkgs.hugo
    pkgs.just
  ];
}
