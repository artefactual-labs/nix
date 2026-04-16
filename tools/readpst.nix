let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "readpst";
  binary = "readpst";
  expectedVersion = "0.6.76";
  package = pkgs: pkgs.libpst;
}
