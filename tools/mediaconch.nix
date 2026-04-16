let
  version = "25.04";
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "mediaconch";
  binary = "mediaconch";
  expectedVersion = version;
  package = pkgs:
    pkgs.callPackage ../pkgs/mediaconch {
      inherit version;
      srcHash = "sha256-dVbrmOLRVqygiRPskdEYCq7z9+czl/XsVDBNboKlqGk=";
      libmediainfoSrcHash = "sha256-rUXtfJ23gHqoA4RcqIutlSaqjaiDpYEn5TkKqi2Bu7E=";
    };
}
