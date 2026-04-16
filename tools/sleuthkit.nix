let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "sleuthkit";
  binary = "fiwalk";
  appAliases = [ "tsk_recover" ];
  expectedVersion = "4.12.1";
  package = pkgs: pkgs.sleuthkit;
}
