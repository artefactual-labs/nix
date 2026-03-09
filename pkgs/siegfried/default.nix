{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  version,
  srcHash,
  vendorHash,
}:
buildGoModule {
  pname = "siegfried";
  inherit version vendorHash;

  src = fetchFromGitHub {
    owner = "richardlehane";
    repo = "siegfried";
    rev = "v${version}";
    hash = srcHash;
  };

  subPackages = [
    "cmd/sf"
    "cmd/roy"
  ];

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  postInstall = ''
    mkdir -p $out/share/siegfried
    cp -R cmd/roy/data/. $out/share/siegfried/

    mkdir -p $out/libexec
    mv $out/bin/sf $out/libexec/sf
    mv $out/bin/roy $out/libexec/roy

    makeWrapper $out/libexec/sf $out/bin/sf \
      --set-default SIEGFRIED_HOME $out/share/siegfried
    makeWrapper $out/libexec/roy $out/bin/roy \
      --set-default SIEGFRIED_HOME $out/share/siegfried
  '';

  meta = with lib; {
    description = "Signature-based file format identification tool";
    homepage = "https://www.itforarchivists.com/siegfried";
    license = licenses.asl20;
    mainProgram = "sf";
    platforms = platforms.linux;
  };
}
