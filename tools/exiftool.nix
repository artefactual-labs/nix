let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "exiftool";
  binary = "exiftool";
  expectedVersion = "12.84";
  package = pkgs: pkgs.exiftool;
}
