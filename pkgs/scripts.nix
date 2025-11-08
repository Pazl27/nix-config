# pkgs/scripts.nix
{ stdenv, lib }:

stdenv.mkDerivation {
  pname = "scripts";
  version = "1.0";
  src = ./../scripts;

  installPhase = ''
    mkdir -p $out/share/scripts
    cp -r $src/* $out/share/scripts/
  '';

  meta = with lib; {
    description = "Personal scripts collection";
    license = licenses.mit;
  };
}
