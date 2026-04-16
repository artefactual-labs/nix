let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "tree";
  binary = "tree";
  expectedVersion = "2.1.2";
  package = pkgs: pkgs.tree;
}
