# https://lazamar.co.uk/nix-versions/

{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # ffmpeg 5.1.3
    ffmpegPkgs.url = "github:nixos/nixpkgs?rev=336eda0d07dc5e2be1f923990ad9fdb6bc8e28e3";

    # imagemagick 7.1.1-34
    imagemagickPkgs.url = "github:nixos/nixpkgs?rev=05bbf675397d5366259409139039af8077d695ce";
  };

  outputs = {
    self,
    nixpkgs,
    ffmpegPkgs,
    imagemagickPkgs,
  }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      ffmpegPackages = import ffmpegPkgs { system = system; };
      imagemagickPackages = import imagemagickPkgs { system = system; };
    in {
      packages.${system} = {
        ffmpeg = ffmpegPackages.ffmpeg_5-headless;
        imagemagick = imagemagickPackages.imagemagick;
      };
      apps.${system} = {
        ffmpeg = {
          type = "app";
          program = "${self.packages.${system}.ffmpeg}/bin/ffmpeg";
        };
        magick = {
          type = "app";
          program = "${self.packages.${system}.imagemagick}/bin/magick";
        };
      };
      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs = [
            self.packages.${system}.ffmpeg
            self.packages.${system}.imagemagick
          ];
        };
      };
    };
}
