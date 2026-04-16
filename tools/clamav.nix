let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "clamav";
  binary = "clamscan";
  appAliases = [
    "freshclam"
    "clamd"
  ];
  expectedVersion = "1.3.1";
  package = pkgs:
    pkgs.clamav.overrideAttrs (_: {
      doCheck = false;
    });
}
