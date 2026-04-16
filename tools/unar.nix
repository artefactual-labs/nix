let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "unar";
  binary = "unar";
  expectedVersion = "1.10.7";
  package = pkgs: pkgs.unar;
}
