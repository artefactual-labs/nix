let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "gzip";
  binary = "gzip";
  expectedVersion = "1.13";
  package = pkgs: pkgs.gzip;
}
