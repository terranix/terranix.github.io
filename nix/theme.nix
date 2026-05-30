{
  pkgs ? import <nixpkgs> { },
}:

pkgs.stdenv.mkDerivation {
  pname = "hugo-theme-terratheme";
  version = "0.1.0";

  src = pkgs.lib.cleanSource ../themes/terratheme;

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';

  meta = with pkgs.lib; {
    description = "Hugo theme for terranix.org";
    platforms = platforms.all;
  };
}
