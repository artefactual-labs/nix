# syntax=docker/dockerfile:1.7

ARG UBUNTU_IMAGE=ubuntu:noble-20260210.1
ARG TOOLCHAIN_PACKAGE=archivematica-toolchain

FROM nixos/nix:2.29.0 AS builder

ARG TOOLCHAIN_PACKAGE

WORKDIR /src

COPY . /src

RUN nix --extra-experimental-features "nix-command flakes" \
  build --print-build-logs ".#${TOOLCHAIN_PACKAGE}"

RUN nix --extra-experimental-features "nix-command flakes" \
  shell nixpkgs#bash nixpkgs#coreutils --command \
  bash -lc "mkdir -p /tmp/closure/nix/store /tmp/closure/usr/local/bin && cp -a --parents \$(nix-store --query --requisites /src/result) /tmp/closure && cp -a /src/result/bin/. /tmp/closure/usr/local/bin/"

FROM ${UBUNTU_IMAGE}

COPY --from=builder /tmp/closure/ /

ENV PATH=/usr/local/bin:${PATH}
