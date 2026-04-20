let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "gnupg";
  binary = "gpg";
  expectedVersion = "2.4.5";
  package = pkgs: pkgs.gnupg;
}
