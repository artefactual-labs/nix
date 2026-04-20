let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "git";
  binary = "git";
  expectedVersion = "2.45.2";
  package = pkgs: pkgs.git;
}
