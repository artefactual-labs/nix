# Archivematica Tool Inventory

This file tracks the external Archivematica tools we want to reproduce in the
Nix-based toolchain and the current implementation status of each one.

The initial scope covers:

- the two tools already prototyped in this repository;
- the three tools currently supplied by
  `packages.archivematica.org/1.19.x/ubuntu-externals` for Ubuntu 24.04
  (`noble`).

| Tool | Current baseline version | Current source | In `nixpkgs`? | Proposed Nix strategy | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `ffmpeg` | `7:6.1.1-3ubuntu5` | Ubuntu noble/universe | Yes | Keep using a pinned `nixpkgs` source for the exact version we want to publish | `prototype implemented` | Already modeled in this repo with an explicit pinned source and expected version `5.1.3`. |
| `imagemagick` | `8:6.9.12.98+dfsg1-5.2build2` | Ubuntu noble/universe | Yes | Keep using a pinned `nixpkgs` source for the exact version we want to publish | `prototype implemented` | Already modeled in this repo with an explicit pinned source and expected version `7.1.1-34`. |
| `bulk-extractor` | `2.1.1-1~24.04` | Archivematica externals | Yes, as `bulk_extractor` `2.1.1` | Use `nixpkgs` package directly, then pin the source in this repo | `prototype implemented` | Implemented in this repo with a pinned `nixpkgs` source. Upstream version matches the Archivematica package; only the Debian revision suffix differs. |
| `jhove` | `1.34.0-1~22.04` | Archivematica externals | No | Build upstream `openpreserve/jhove` from source in Nix, install the CLI JAR set and config directly, and run it with a pinned Java 8 runtime | `prototype implemented` | Implemented in this repo as a custom Maven package. The package builds upstream `v1.34.0`, installs the module JARs/config under `share/jhove`, and pins JHOVE's embedded release timestamp to the upstream tag commit date for deterministic metadata. |
| `siegfried` | `1.11.2-1` | Archivematica externals | No | Package upstream release in this repo with bundled signature data and explicit wrappers for `sf` / `roy` | `prototype implemented` | Implemented in this repo as a custom Go package. The package ships both binaries and the bundled signature data under `share/siegfried`. |

## Sources checked

- Archivematica externals `Release` for `noble`: confirms `amd64` and `arm64`
  are published.
- Archivematica externals `Packages.gz` for `noble`: confirms the current
  package versions for `bulk-extractor`, `jhove`, and `siegfried`.
- Archivematica Docker baseline: the `base` stage in the Archivematica
  Dockerfile provides the current Ubuntu package selections for `ffmpeg` and
  `imagemagick`.
- `nixpkgs`:
  - locked rev in this repo: `693bc46d169f5af9c992095736e82c3488bf7dbb`
  - current `nixos-unstable` branch at inspection time

In both `nixpkgs` checks, `bulk_extractor` exists and `jhove` / `siegfried`
do not appear to be packaged.
