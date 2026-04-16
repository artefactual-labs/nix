# Archivematica Toolchain

This repository defines the concept and prototype implementation of an
`archivematica-toolchain`: a controlled, versioned set of external system
tools for Archivematica.

## Problem

Archivematica is distributed in multiple ways today, including Docker images,
Debian packages, RPM packages, and Ansible-managed environments.

That flexibility is useful, but it also means there is no single,
source-controlled definition of the external tools Archivematica depends on.
Those tools are currently resolved through distribution-specific package
managers and repositories, which makes it harder to answer questions like:

- What exact version of `ffmpeg` are we shipping?
- Which `jhove` or `siegfried` build should an Archivematica deployment
  expect?
- How do we deliver the same dependency contract across Docker and more
  traditionally-managed environments?
- How do we upgrade these dependencies deliberately instead of inheriting
  repository drift?

Today, the Archivematica Docker baseline pulls packages from a mix of Ubuntu
repositories, Archivematica externals, and MediaArea packages.
That works, but it is not yet a single deterministic dependency contract.

## Goal

The goal of this project is to publish a named toolchain for Archivematica:

- curated rather than incidental;
- versioned as one compatibility unit;
- defined in source control;
- buildable into downstream artifacts from one canonical description.

Consumers should be able to talk about "Archivematica toolchain version X"
instead of reconstructing the dependency story package by package.

## Scope Boundary

This repository is responsible for external tools that Archivematica expects
the execution environment to provide independently of Archivematica's own
Python application dependencies.

That means [tools.toml](tools.toml) should include tools such as `ffmpeg`,
`jhove`, `siegfried`, `7z`, `tree`, or `mediainfo` when Archivematica expects
them to be present as system-level commands.

It should not include Python-provided console scripts or libraries that are
already delivered by Archivematica itself through `pyproject.toml` /
`requirements.txt`, even if Archivematica later invokes them through
`subprocess`. Those belong to the Archivematica application environment, not
to this repo's independent toolchain contract.

## Why "Toolchain"

We call this a toolchain because the value is not just in collecting packages.
The value is in releasing a known-good set of external tools together, with
versions chosen intentionally for Archivematica workflows.

In digital preservation, that matters for reasons beyond convenience.
Preservation actions are often defined in terms of specific tools, parameters,
and execution environments. [PAR](https://parcore.org/), for example, models
preservation actions as explicit descriptions of the tool to invoke, the
arguments to pass, and the operating environment. If those details are left
implicit, institutions can share policy intent without actually sharing the
same executable behavior.

A named, versioned toolchain improves:

- predictability, because the same workflow runs against the same tool versions
  across deployments;
- reviewability, because behavior changes show up as explicit toolchain
  upgrades instead of ambient repository updates;
- comparability, because institutions can relate outcomes to a known execution
  stack instead of an assumed one;
- reuse, because preservation policies and action definitions are easier to
  exchange when the execution layer is itself a published compatibility
  contract.

This distinguishes the project from:

- the Archivematica application itself;
- a generic Ubuntu base image;
- language-specific development dependencies;
- a repository that manages only one package.

## Why Nix

Nix is the definition and build layer for this effort.

For this project, that means:

- package sources can be pinned and reviewed in source control;
- upgrades become explicit changes instead of repository drift;
- the same toolchain definition can be used for Docker, local development, and
  other downstream distribution formats;
- one source of truth can produce multiple artifacts.

Nix does not have to be a runtime requirement on every target system. A
practical model is:

- Nix defines the canonical toolchain;
- CI builds artifacts from that definition;
- downstream consumers receive Docker images, packages, or other artifacts
  suited to their environment.

## Deliverables

This repository is intended to produce two primary artifact types.

### Docker Artifact

A Docker image providing a stable Archivematica toolchain on top of Ubuntu
24.04, suitable for use as a base image for Archivematica-related containers.

### Nix Artifact

A flake exposing the toolchain for Nix-native use, including:

- a package named `archivematica-toolchain`;
- a development shell for maintainers;
- supporting package outputs for individual tools;
- optionally, OCI image outputs built directly by Nix.

## Versioning Model

This project needs two layers of versioning.

### Toolchain Release Version

The toolchain itself should have a release version such as `v1.2.3`.

That version represents:

- the selected set of managed tools;
- the exact resolved versions of those tools;
- the compatibility contract being published to Archivematica consumers.

### Locked Build Inputs

The lock file is the machine-precise description of the package sources used to
build the toolchain.

Releases should also publish a human-readable manifest of included tool
versions so the compatibility contract is easy to review.

## Documents

- [tools.toml](tools.toml) is the machine-readable manifest of Archivematica
  external tools that this repository is expected to provide independently of
  Archivematica's Python dependencies. Each entry describes the tool
  Archivematica expects, the binaries it may invoke, and optionally the
  package name this repository exposes for that tool.
- [tools](tools) contains the Nix tool definitions that turn those tool names
  into flake package outputs.
- [pkgs](pkgs) contains custom package implementations used by some tool
  definitions when taking a package directly from `nixpkgs` is not sufficient.
- [CONTRIBUTING.md](CONTRIBUTING.md) describes the repository layout,
  contributor workflow, and verification commands.

## Status

This repository is still a prototype, but it already demonstrates the intended
shape:

- small per-tool definitions;
- pinned package sources;
- custom packaging where `nixpkgs` is insufficient;
- multi-architecture Linux outputs;
- a Docker path that uses Ubuntu 24.04 as the final base image.
