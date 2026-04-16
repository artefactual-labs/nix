let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "pbzip2";
  binary = "pbzip2";
  expectedVersion = "1.1.13";
  package = pkgs: pkgs.pbzip2;
}
