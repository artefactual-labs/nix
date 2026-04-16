let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "tesseract";
  binary = "tesseract";
  expectedVersion = "5.3.4";
  package = pkgs: pkgs.tesseract;
}
