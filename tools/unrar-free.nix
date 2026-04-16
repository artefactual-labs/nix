let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "unrar-free";
  binary = "unrar-free";
  expectedVersion = "0.3.0";
  package = pkgs: pkgs."unrar-free";
}
