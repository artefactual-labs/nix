let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "mediainfo";
  binary = "mediainfo";
  expectedVersion = "24.06";
  package = pkgs: pkgs.mediainfo;
}
