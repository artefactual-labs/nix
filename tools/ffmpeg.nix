{
  name = "ffmpeg";
  source = {
    name = "nixpkgs-ffmpeg-5-1-3";
    fetchTree = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      rev = "336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";
      narHash = "sha256-mYJwTy2TNTOXbxVtmhXDv98F2ORhxRzL1S6yw1+1G20=";
    };
  };
  binary = "ffmpeg";
  expectedVersion = "5.1.3";
  package = pkgs: pkgs.ffmpeg_5-headless;
}
