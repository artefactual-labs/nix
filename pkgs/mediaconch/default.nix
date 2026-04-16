{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libxml2,
  libxslt,
  sqlite,
  jansson,
  curl,
  libevent,
  zlib,
  libzen,
  callPackage,
  version ? "25.04",
  srcHash,
  libmediainfoSrcHash,
}:

let
  libmediainfo = callPackage ../libmediainfo {
    inherit libzen version;
    srcHash = libmediainfoSrcHash;
  };
in
stdenv.mkDerivation rec {
  pname = "mediaconch";
  inherit version;

  src = fetchurl {
    url = "https://mediaarea.net/download/source/mediaconch/${version}/mediaconch_${version}.tar.xz";
    hash = srcHash;
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    jansson
    libevent
    libmediainfo
    libxml2
    libxslt
    sqlite
    zlib
  ];

  sourceRoot = "MediaConch/Project/GNU/CLI";

  postPatch = lib.optionalString (stdenv.cc.targetPrefix != "") ''
    substituteInPlace configure.ac \
      --replace "pkg-config " "${stdenv.cc.targetPrefix}pkg-config "
  '';

  configureFlags = [
    "--with-sqlite"
    "--with-jansson"
    "--with-libevent"
  ];

  doCheck = false;
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Implementation and policy checker for preservation-level audiovisual files";
    homepage = "https://mediaarea.net/MediaConch/";
    changelog = "https://mediaarea.net/MediaConch/ChangeLog";
    license = with licenses; [ gpl3Plus mpl20 ];
    mainProgram = "mediaconch";
    platforms = platforms.linux;
  };
}
