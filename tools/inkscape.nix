let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "inkscape";
  binary = "inkscape";
  expectedVersion = "1.3.2";
  package = pkgs: pkgs.inkscape;
}
