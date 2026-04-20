# Contributing

This document covers the technical details of the repository: layout,
maintenance workflow, and basic verification commands.

## Document Roles

- [README.md](README.md) is the authoritative description of the concept and
  purpose of this effort.
- [tools.toml](tools.toml) is the machine-readable manifest of Archivematica
  tools that this repository must provide independently of Archivematica's
  Python dependencies, plus the optional package name this repository exposes
  for each one.
- This file covers contributor workflow and repository mechanics.

## Repository Layout

- [flake.nix](flake.nix): flake entrypoint and per-system output wiring.
- [lib/tool-definitions.nix](lib/tool-definitions.nix): collects the per-tool
  Nix definitions from [tools](tools).
- [lib/mk-toolchain.nix](lib/mk-toolchain.nix): assembles tool definitions
  into packages, apps, and manifests.
- [tools.toml](tools.toml): canonical manifest of Archivematica tools.
- [tools](tools): one small Nix definition per tool, mapping a tool name to
  the package this repo exposes for it.
- [pkgs](pkgs): custom package implementations used by some entries in
  [tools](tools). Not every tool has a matching `pkgs/<name>` directory.
- [Dockerfile](Dockerfile): Docker-based build path for the Ubuntu 24.04 base
  image prototype.

## Working Model

Use the following split when adding or changing a tool:

- record or update the Archivematica-facing contract in `tools.toml`;
- put the Nix tool definition in `tools/<name>.nix`;
- keep custom packaging logic in `pkgs/<name>/default.nix`;
- keep `flake.nix` focused on wiring, not per-tool logic.

Before adding a new `tools.toml` entry, check the boundary first:

- include commands that the execution environment must provide independently
  of Archivematica itself;
- exclude Python libraries or console scripts already delivered by
  Archivematica's own application environment, even if they are later invoked
  through `subprocess`.

Tool definitions should describe:

- tool name;
- expected version;
- deployment groups when the tool belongs to a specific runtime image such as
  `archivematica` or `storage-service`;
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

Build the Archivematica toolchain package:

```sh
nix build .#packages.x86_64-linux.archivematica-toolchain
```

Build the storage-service toolchain package:

```sh
nix build .#packages.x86_64-linux.archivematica-storage-service-toolchain
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

Build the ARM64 Ubuntu Archivematica toolchain image:

```sh
docker buildx build --platform linux/arm64 --load \
  -t archivematica-toolchain:test .
```

Build the ARM64 Ubuntu storage-service toolchain image:

```sh
docker buildx build --platform linux/arm64 --load \
  --build-arg TOOLCHAIN_PACKAGE=archivematica-storage-service-toolchain \
  -t archivematica-storage-service-toolchain:test .
```

Smoke-test the Archivematica Docker image:

```sh
docker run --rm --platform linux/arm64 archivematica-toolchain:test ffmpeg -version
docker run --rm --platform linux/arm64 archivematica-toolchain:test magick -version
```

Or run the shared smoke-test script used by CI:

```sh
./scripts/smoke-test-docker-image.sh archivematica-toolchain:test linux/arm64 archivematica
./scripts/smoke-test-docker-image.sh archivematica-storage-service-toolchain:test linux/arm64 storage-service
```

The smoke-test script is the preferred local verification path after Docker
builds. It checks representative tools from the final image and also verifies
that `version-report` is available in the assembled toolchain path.

If a command works as `nix run .#<tool>` or as an individual package build but
is missing from the Docker image, check the final assembly in
[lib/mk-toolchain.nix](lib/mk-toolchain.nix), not just the tool definition.

## Current Implementation Notes

- `ffmpeg`, `imagemagick`, and `bulk-extractor` currently resolve from pinned
  `nixpkgs` sources.
- `siegfried` is packaged locally from upstream Go source and exposes both
  `sf` and `roy`.
- `jhove` is packaged locally from upstream Maven source and runs with pinned
  Java 8 from `nixpkgs`.
- `mediaconch` is packaged locally from MediaArea source together with a local
  `libmediainfo` package.
- The Docker prototype uses `ubuntu:noble-20260210.1` as the final base image.

## CI Verification

- Pull requests call [.github/workflows/_build.yml](.github/workflows/_build.yml)
  through [.github/workflows/pr.yml](.github/workflows/pr.yml).
- The shared build workflow builds both Docker images for `linux/amd64` and
  `linux/arm64`, then runs the same smoke-test script contributors can run
  locally.
- Keep CI smoke coverage in `scripts/smoke-test-docker-image.sh` so local and
  PR validation stay aligned.

## Updating Tools

When updating a tool:

1. Update `tools.toml`.
2. Update the tool definition or custom package if the tool is managed here.
3. If the tool comes from a shared source such as `nixpkgs`, make sure the
   source and package mapping still resolve cleanly through
   [lib/tool-definitions.nix](lib/tool-definitions.nix) and
   [lib/mk-toolchain.nix](lib/mk-toolchain.nix).
4. Verify the tool builds for at least one Linux target.
5. Rebuild the relevant Docker image and run
   `./scripts/smoke-test-docker-image.sh <image> <platform> <profile>`.
6. Update [README.md](README.md) only if the conceptual framing changed.
