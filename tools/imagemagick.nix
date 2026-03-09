{
  name = "imagemagick";
  source = {
    name = "nixpkgs-imagemagick-7-1-1-34";
    fetchTree = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      rev = "05bbf675397d5366259409139039af8077d695ce";
      narHash = "sha256-IE7PZn9bSjxI4/MugjAEx49oPoxu0uKXdfC+X7HcRuQ=";
    };
  };
  binary = "magick";
  expectedVersion = "7.1.1-34";
  package = pkgs: pkgs.imagemagick;
}
