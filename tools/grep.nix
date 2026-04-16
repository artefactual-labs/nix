let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "grep";
  binary = "grep";
  expectedVersion = "3.11";
  package = pkgs: pkgs.gnugrep;
}
