let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "rsync";
  binary = "rsync";
  expectedVersion = "3.3.0";
  package = pkgs: pkgs.rsync;
}
