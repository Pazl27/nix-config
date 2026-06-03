# pkgs/vi-sql.nix
{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "vi-sql";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kopecmaciej";
    repo = "vi-sql";
    rev = "v${version}";
    hash = "sha256-wIQpeeM3edPEgxoaM1JNP2yUo/iNuv3rFv9rcV2eN2k=";
  };

  vendorHash = "sha256-Sb/UUWXT/XMM4hxc0VHbzRiaCtOF0W6lirY1EnASTfw=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/kopecmaciej/vi-sql/internal/build.Version=v${version}"
  ];

  doCheck = false;

  meta = {
    description = "Terminal UI for managing SQL databases (PostgreSQL, MySQL, SQLite, MSSQL)";
    homepage = "https://github.com/kopecmaciej/vi-sql";
    license = lib.licenses.mit;
    mainProgram = "vi-sql";
    platforms = lib.platforms.unix;
  };
}
