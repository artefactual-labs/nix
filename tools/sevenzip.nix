let
  mkTool = import ../lib/mk-nixpkgs-tool.nix;
in
mkTool {
  name = "sevenzip";
  binary = "7z";
  expectedVersion = "24.07";
  package = pkgs:
    pkgs.symlinkJoin {
      name = "sevenzip-${pkgs._7zz.version}";
      paths = [ pkgs._7zz ];
      postBuild = ''
        ln -s $out/bin/7zz $out/bin/7z
      '';
    };
}
