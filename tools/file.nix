let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "file";
  binary = "file";
  expectedVersion = "5.45";
  package = pkgs: pkgs.file;
}
