let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "coreutils-hashsum";
  binary = "md5sum";
  appAliases = [
    "sha1sum"
    "sha256sum"
    "sha512sum"
  ];
  expectedVersion = "9.5";
  package = pkgs: pkgs.coreutils;
}
