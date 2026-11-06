{ stdenv, lib }:

stdenv.mkDerivation {
  pname = "scripts";
  version = "1.0";
  src = ../scripts;

  installPhase = ''
    mkdir -p $out/share/scripts
    cp -r $src/* $out/share/scripts/
    find $out/share/scripts -type f -name '*.sh' -exec chmod +x {} +
  '';

  meta = with lib; {
    description = "Personal scripts collection";
    license = licenses.mit;
  };
}
