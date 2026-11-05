# Overlay with the packages defined in this repository.
final: _prev: {
  my-scripts = final.callPackage ./scripts.nix { };
  vi-sql = final.callPackage ./vi-sql.nix { };
}
