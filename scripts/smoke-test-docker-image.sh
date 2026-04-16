#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "usage: $0 <image> [platform]" >&2
  exit 64
fi

image="$1"
platform="${2:-linux/arm64}"

docker_run() {
  docker run --rm --platform "${platform}" "${image}" "$@"
}

docker_run ffmpeg -version
docker_run magick -version
docker_run mediaconch --version
docker_run mediainfo --Version
docker_run sf -version
docker_run jhove -h
docker_run clamscan --version
docker_run tesseract --version
docker_run 7z
docker_run unar -version

tmp_versions="$(mktemp)"
trap 'rm -f "${tmp_versions}"' EXIT

docker_run version-report | tee "${tmp_versions}"
grep -Fx 'mediaconch 25.04' "${tmp_versions}"
grep -Fx 'ffmpeg 5.1.3' "${tmp_versions}"
