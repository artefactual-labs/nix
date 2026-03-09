let
  version = "1.34.0";
in {
  name = "jhove";
  source = {
    name = "nixpkgs-java-builder";
    fetchTree = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      rev = "693bc46d169f5af9c992095736e82c3488bf7dbb";
      narHash = "sha256-oedh2RwpjEa+TNxhg5Je9Ch6d3W1NKi7DbRO1ziHemA=";
    };
  };
  binary = "jhove";
  expectedVersion = "1.34.0";
  package = pkgs:
    pkgs.callPackage ../pkgs/jhove {
      inherit version;
      srcHash = "sha256-2JpMIf//qlKZ3m4d5TaLIa0Irjq+mxP5dbAlY+sYg1Q=";
      mvnHash = "sha256-NcK8zVpums5IQtQY4E6Hx3MOe2riD/+7IaIAxuoyyW0=";
    };
}
