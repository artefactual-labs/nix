let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "atool";
  binary = "atool";
  expectedVersion = "0.39.0";
  package = pkgs: pkgs.atool;
}
