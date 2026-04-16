let
  tools = [
    (import ../tools/atool.nix)
    (import ../tools/awk.nix)
    (import ../tools/bulk-extractor.nix)
    (import ../tools/clamav.nix)
    (import ../tools/coreutils-fileops.nix)
    (import ../tools/coreutils-hashsum.nix)
    (import ../tools/exiftool.nix)
    (import ../tools/file.nix)
    (import ../tools/ffmpeg.nix)
    (import ../tools/gnu-tar.nix)
    (import ../tools/ghostscript.nix)
    (import ../tools/grep.nix)
    (import ../tools/gzip.nix)
    (import ../tools/imagemagick.nix)
    (import ../tools/inkscape.nix)
    (import ../tools/jhove.nix)
    (import ../tools/mediaconch.nix)
    (import ../tools/mediainfo.nix)
    (import ../tools/pbzip2.nix)
    (import ../tools/readpst.nix)
    (import ../tools/rsync.nix)
    (import ../tools/sevenzip.nix)
    (import ../tools/siegfried.nix)
    (import ../tools/sleuthkit.nix)
    (import ../tools/tesseract.nix)
    (import ../tools/tree.nix)
    (import ../tools/unar.nix)
    (import ../tools/unrar-free.nix)
  ];
in
  builtins.listToAttrs (map (tool: {
      name = tool.name;
      value = tool;
    })
    tools)
