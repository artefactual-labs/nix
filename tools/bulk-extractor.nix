{
  name = "bulk-extractor";
  source = {
    name = "nixpkgs-bulk-extractor-2-1-1";
    fetchTree = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      rev = "693bc46d169f5af9c992095736e82c3488bf7dbb";
      narHash = "sha256-oedh2RwpjEa+TNxhg5Je9Ch6d3W1NKi7DbRO1ziHemA=";
    };
  };
  binary = "bulk_extractor";
  expectedVersion = "2.1.1";
  package = pkgs: pkgs.bulk_extractor;
}
