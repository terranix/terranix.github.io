{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  pname = "terranix-org";
  version = "0.1.0";

  src = pkgs.lib.cleanSource ../.;

  nativeBuildInputs = [ pkgs.hugo ];

  buildPhase = ''
    hugo --minify
  '';

  installPhase = ''
    cp -r public $out
  '';

  meta = with pkgs.lib; {
    description = "The new terranix.org website";
    homepage = "https://terranix.org";
    platforms = platforms.all;
  };
}
