{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  maven,
  jdk8_headless,
  version,
  srcHash,
  mvnHash,
}:
maven.buildMavenPackage {
  pname = "jhove";
  inherit version mvnHash;

  src = fetchFromGitHub {
    owner = "openpreserve";
    repo = "jhove";
    rev = "v${version}";
    hash = srcHash;
  };

  mvnParameters = lib.escapeShellArgs [
    "-pl"
    "jhove-apps,jhove-ext-modules,jhove-modules/aiff-hul,jhove-modules/ascii-hul,jhove-modules/gif-hul,jhove-modules/html-hul,jhove-modules/jpeg-hul,jhove-modules/jpeg2000-hul,jhove-modules/pdf-hul,jhove-modules/tiff-hul,jhove-modules/utf8-hul,jhove-modules/wave-hul,jhove-modules/xml-hul"
    "-am"
    "-DskipTests"
    "-Djhove.timestamp=2025-07-01 14:06:18"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/jhove/bin" "$out/share/jhove/conf"

    cp jhove-apps/target/jhove-apps-${version}.jar "$out/share/jhove/bin/"
    cp jhove-ext-modules/target/jhove-ext-modules-${version}.jar "$out/share/jhove/bin/"

    for jar in \
      jhove-modules/aiff-hul/target/aiff-hul-1.6.2.jar \
      jhove-modules/ascii-hul/target/ascii-hul-1.4.2.jar \
      jhove-modules/gif-hul/target/gif-hul-1.4.3.jar \
      jhove-modules/html-hul/target/html-hul-1.4.5.jar \
      jhove-modules/jpeg-hul/target/jpeg-hul-1.5.4.jar \
      jhove-modules/jpeg2000-hul/target/jpeg2000-hul-1.4.5.jar \
      jhove-modules/pdf-hul/target/pdf-hul-1.12.8.jar \
      jhove-modules/tiff-hul/target/tiff-hul-1.9.5.jar \
      jhove-modules/utf8-hul/target/utf8-hul-1.7.5.jar \
      jhove-modules/wave-hul/target/wave-hul-1.8.3.jar \
      jhove-modules/xml-hul/target/xml-hul-1.5.5.jar
    do
      cp "$jar" "$out/share/jhove/bin/"
    done

    cp jhove-installer/src/main/config/jhove.conf "$out/share/jhove/conf/jhove.conf"
    substituteInPlace "$out/share/jhove/conf/jhove.conf" \
      --replace-fail '$INSTALL_PATH' "$out/share/jhove"

    cat > "$out/bin/jhove" <<EOF
    #!${stdenvNoCC.shell}
    exec ${jdk8_headless}/bin/java \\
      -Xss1024k \\
      -classpath "$out/share/jhove/bin/*" \\
      edu.harvard.hul.ois.jhove.Jhove \\
      -c "$out/share/jhove/conf/jhove.conf" \\
      "\$@"
    EOF
    chmod +x "$out/bin/jhove"

    runHook postInstall
  '';

  meta = {
    description = "JHOVE file format identification, validation, and characterization";
    homepage = "https://github.com/openpreserve/jhove";
    license = lib.licenses.lgpl21Only;
    mainProgram = "jhove";
    platforms = lib.platforms.linux;
  };
}
