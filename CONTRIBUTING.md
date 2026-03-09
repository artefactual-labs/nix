# Contributing

This document covers the technical details of the repository: layout,
maintenance workflow, and basic verification commands.

## Document Roles

- [README.md](README.md) is the authoritative description of the concept and
  purpose of this effort.
- [TOOLS.md](TOOLS.md) tracks tool scope, baseline versions, and
  implementation status.
- This file covers contributor workflow and repository mechanics.

## Repository Layout

- [flake.nix](flake.nix): flake entrypoint and per-system output wiring.
- [lib/mk-toolchain.nix](lib/mk-toolchain.nix): assembles tool definitions
  into packages, apps, and manifests.
- [tools](tools): one small definition file per tool.
- [pkgs](pkgs): custom package implementations for tools that cannot be taken
  directly from `nixpkgs`.
- [Dockerfile](Dockerfile): Docker-based build path for the Ubuntu 24.04 base
  image prototype.

## Working Model

Use the following split when adding or changing a tool:

- put descriptive metadata in `tools/<name>.nix`;
- keep custom packaging logic in `pkgs/<name>/default.nix`;
- keep `flake.nix` focused on wiring, not per-tool logic.

Tool definitions should describe:

- tool name;
- expected version;
- pinned source selection;
- primary binary name;
- package resolver.

Custom package implementations should contain:

- fetch/build logic;
- runtime wrappers;
- install layout;
- any reproducibility fixes specific to that tool.

## Supported Platforms

Current outputs target:

- `x86_64-linux`
- `aarch64-linux`

This repository is maintained from macOS as well, but full realization of
Linux outputs may require Docker or Linux builders.

## Common Commands

Inspect flake outputs:

```sh
nix flake show
```

Open the maintainer shell:

```sh
nix develop
```

Run an individual tool:

```sh
nix run .#ffmpeg -- -version
```

Build the combined toolchain package:

```sh
nix build .#packages.x86_64-linux.archivematica-toolchain
```

Build the ARM64 Linux JHOVE package through Docker:

```sh
docker run --rm --platform linux/arm64 \
  -v "$(pwd)":/src \
  -w /src \
  nixos/nix sh -lc \
  'nix build path:/src#packages.aarch64-linux.jhove \
    --extra-experimental-features "nix-command flakes"'
```

Build the ARM64 Ubuntu toolchain image:

```sh
docker buildx build --platform linux/arm64 --load \
  -t archivematica-toolchain:test .
```

Smoke-test the Docker image:

```sh
docker run --rm --platform linux/arm64 archivematica-toolchain:test ffmpeg -version
docker run --rm --platform linux/arm64 archivematica-toolchain:test magick -version
```

## Current Implementation Notes

- `ffmpeg`, `imagemagick`, and `bulk-extractor` currently resolve from pinned
  `nixpkgs` sources.
- `siegfried` is packaged locally from upstream Go source and exposes both
  `sf` and `roy`.
- `jhove` is packaged locally from upstream Maven source and runs with pinned
  Java 8 from `nixpkgs`.
- The Docker prototype uses `ubuntu:noble-20260210.1` as the final base image.

## Updating Tools

When updating a tool:

1. Update the tool definition or custom package.
2. Verify the tool builds for at least one Linux target.
3. Update [TOOLS.md](TOOLS.md) if scope, strategy,
   or status changed.
4. Update [README.md](README.md) only if the
   conceptual framing changed.

## Baseline Tracking

The current Docker/package baseline for Archivematica should be treated as the
reference point for deciding what belongs in the toolchain, but baseline
inventory details belong in [TOOLS.md](TOOLS.md),
not in the README.
