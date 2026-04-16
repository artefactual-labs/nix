let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "coreutils-fileops";
  binary = "cp";
  appAliases = [
    "mv"
    "mkdir"
    "chmod"
    "test"
  ];
  expectedVersion = "9.5";
  package = pkgs: pkgs.coreutils;
}
