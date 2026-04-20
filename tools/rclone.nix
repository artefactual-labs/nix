let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "rclone";
  binary = "rclone";
  expectedVersion = "1.67.0";
  package = pkgs: pkgs.rclone;
}
