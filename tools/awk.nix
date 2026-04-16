let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "awk";
  binary = "awk";
  expectedVersion = "5.2.2";
  package = pkgs: pkgs.gawk;
}
