#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 || $# -gt 3 ]]; then
  echo "usage: $0 <image> [platform] [profile]" >&2
  exit 64
fi

image="$1"
platform="${2:-linux/arm64}"
profile="${3:-archivematica}"

docker_run() {
  docker run --rm --platform "${platform}" "${image}" "$@"
}

assert_missing() {
  if docker_run "$@" >/dev/null 2>&1; then
    echo "unexpected command present in ${profile} image: $*" >&2
    exit 1
  fi
}

tmp_versions="$(mktemp)"
trap 'rm -f "${tmp_versions}"' EXIT

case "${profile}" in
  archivematica)
    docker_run ffmpeg -version
    docker_run magick -version
    docker_run mediaconch --version
    docker_run mediainfo --Version
    docker_run sf -version
    docker_run jhove -h
    docker_run clamscan --version
    docker_run tesseract --version
    docker_run 7z
    docker_run git --version
    docker_run gpg --version
    docker_run rclone version
    docker_run lsar -version
    docker_run unar -version

    docker_run version-report | tee "${tmp_versions}"
    grep -Fx 'mediaconch 25.04' "${tmp_versions}"
    grep -Fx 'ffmpeg 5.1.3' "${tmp_versions}"
    grep -Fx 'git 2.45.2' "${tmp_versions}"
    grep -Fx 'gnupg 2.4.5' "${tmp_versions}"
    grep -Fx 'rclone 1.67.0' "${tmp_versions}"
    ;;
  storage-service)
    docker_run 7z
    docker_run git --version
    docker_run gpg --version
    docker_run tar --version
    docker_run chmod --version
    docker_run rsync --version
    docker_run tree --version
    docker_run rclone version
    docker_run lsar -version
    docker_run unar -version

    docker_run version-report | tee "${tmp_versions}"
    grep -Fx 'sevenzip 24.07' "${tmp_versions}"
    grep -Fx 'git 2.45.2' "${tmp_versions}"
    grep -Fx 'gnupg 2.4.5' "${tmp_versions}"
    grep -Fx 'gnu-tar 1.35' "${tmp_versions}"
    grep -Fx 'rsync 3.3.0' "${tmp_versions}"
    grep -Fx 'tree 2.1.2' "${tmp_versions}"
    grep -Fx 'rclone 1.67.0' "${tmp_versions}"
    grep -Fx 'unar 1.10.7' "${tmp_versions}"
    assert_missing ffmpeg -version
    assert_missing magick -version
    assert_missing mediaconch --version
    ;;
  *)
    echo "unknown smoke-test profile: ${profile}" >&2
    exit 64
    ;;
esac
