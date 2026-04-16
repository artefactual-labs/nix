{
  system,
  pkgs,
  toolDefinitions,
}:
let
  addSource =
    acc: tool:
    let
      source = tool.source;
    in
      if acc ? ${source.name} then
        acc
      else
        acc
        // builtins.listToAttrs [
          {
            name = source.name;
            value = import (builtins.fetchTree source.fetchTree) { inherit system; };
          }
        ];

  sourcePackageSets = builtins.foldl' addSource {} (builtins.attrValues toolDefinitions);

  resolveTool =
    tool:
    let
      packageSet =
        sourcePackageSets.${tool.source.name}
        or (throw "Unknown tool source: ${tool.source.name}");
      package = tool.package packageSet;
    in
      tool
      // {
        inherit package;
      };

  tools = builtins.mapAttrs (_: resolveTool) toolDefinitions;

  toolPackages = builtins.mapAttrs (_: tool: tool.package) tools;

  versionManifest = pkgs.writeText "tool-versions.txt" (
    builtins.concatStringsSep "\n" (
      builtins.map (
        tool:
          "${tool.name} ${tool.expectedVersion}"
      ) (builtins.attrValues tools)
    )
    + "\n"
  );

  versionReport = pkgs.writeShellApplication {
    name = "version-report";
    text = ''
      cat ${versionManifest}
    '';
  };

  mkApp = binary: {
    type = "app";
    program = "${tools.${binary.toolName}.package}/bin/${binary.binaryName}";
  };

  toolAppEntries = builtins.concatLists (
    builtins.map (
      tool:
        [
          {
            name = tool.name;
            value = mkApp {
              toolName = tool.name;
              binaryName = tool.binary;
            };
          }
        ]
        ++ builtins.map (binaryName: {
          name = binaryName;
          value = mkApp {
            toolName = tool.name;
            inherit binaryName;
          };
        }) (tool.appAliases or [ ])
    ) (builtins.attrValues tools)
  );

  toolApps = builtins.listToAttrs toolAppEntries;
in {
  inherit tools toolPackages versionManifest;

  packages =
    toolPackages
    // {
      archivematica-toolchain = pkgs.buildEnv {
        name = "archivematica-toolchain";
        paths = (builtins.attrValues toolPackages) ++ [ versionReport ];
      };

      tool-versions = versionManifest;
      version-report = versionReport;
    };

  apps =
    toolApps
    // {
      version-report = {
        type = "app";
        program = "${versionReport}/bin/version-report";
      };
    };
}
