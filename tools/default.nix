let
  tools = [
    (import ./bulk-extractor.nix)
    (import ./ffmpeg.nix)
    (import ./imagemagick.nix)
    (import ./jhove.nix)
    (import ./siegfried.nix)
  ];
in
  builtins.listToAttrs (map (tool: {
      name = tool.name;
      value = tool;
    })
    tools)
