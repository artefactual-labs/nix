let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "gnu-tar";
  binary = "tar";
  expectedVersion = "1.35";
  package = pkgs: pkgs.gnutar;
}
