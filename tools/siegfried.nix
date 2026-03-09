let
  version = "1.11.2";
in {
  name = "siegfried";
  source = {
    name = "nixpkgs-go-builder";
    fetchTree = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      rev = "693bc46d169f5af9c992095736e82c3488bf7dbb";
      narHash = "sha256-oedh2RwpjEa+TNxhg5Je9Ch6d3W1NKi7DbRO1ziHemA=";
    };
  };
  binary = "sf";
  appAliases = [ "roy" ];
  expectedVersion = version;
  package = pkgs:
    pkgs.callPackage ../pkgs/siegfried {
      inherit version;
      srcHash = "sha256-DThxDVeY1vCG7LUCDAP+zo94bF+Rh+atZ22H9ath8kc=";
      vendorHash = "sha256-jrIbHfnPkkcbak6K491Mzo0nrGFnCiFKn67giGJz4Yg=";
    };
}
