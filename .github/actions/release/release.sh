#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: release.sh [options] <tag>

Options
  --title <title>        Release title (defaults to tag)
  --repo <owner/repo>    Repository slug if not running inside the repo
  --prerelease[=bool]    Mark the release as a prerelease (accepts true/false)
  --dry-run              Show the command without executing it
  -h, --help             Show this help text
USAGE
}

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI is required" >&2
  exit 1
fi

current_tag=""
repo_arg=""
title=""
prerelease_flag=""
dry_run="false"

coerce_boolean() {
  local incoming="$1"
  case "$incoming" in
  true|TRUE|True|1)
    echo "true"
    ;;
  false|FALSE|False|0|"")
    echo "false"
    ;;
  *)
    echo "invalid"
    ;;
  esac
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --title)
    [[ $# -ge 2 ]] || {
      echo "--title requires a value" >&2
      exit 1
    }
    title="$2"
    shift 2
    ;;
  --repo)
    [[ $# -ge 2 ]] || {
      echo "--repo requires a value" >&2
      exit 1
    }
    repo_arg="$2"
    shift 2
    ;;
  --prerelease)
    prerelease_flag="--prerelease"
    shift 1
    ;;
  --prerelease=*)
    value="${1#*=}"
    bool_value="$(coerce_boolean "$value")"
    if [[ "$bool_value" == "invalid" ]]; then
      echo "Invalid value for --prerelease: $value" >&2
      exit 1
    fi
    if [[ "$bool_value" == "true" ]]; then
      prerelease_flag="--prerelease"
    else
      prerelease_flag=""
    fi
    shift 1
    ;;
  --dry-run)
    dry_run="true"
    shift 1
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  --)
    shift 1
    break
    ;;
  -*)
    echo "unrecognized option: $1" >&2
    exit 1
    ;;
  *)
    if [[ -z "$current_tag" ]]; then
      current_tag="$1"
    elif [[ -z "$repo_arg" ]]; then
      repo_arg="$1"
    else
      echo "unexpected argument: $1" >&2
      exit 1
    fi
    shift 1
    ;;
  esac
done

if [[ -z "$current_tag" ]]; then
  usage >&2
  exit 1
fi

repo="${repo_arg:-${GH_REPO:-}}"
if [[ -z "$repo" ]]; then
  repo="$(gh repo view --json nameWithOwner --jq '.nameWithOwner')"
fi

if [[ -z "$title" ]]; then
  title="$current_tag"
fi

if ! git rev-parse -q --verify "refs/tags/${current_tag}" >/dev/null 2>&1; then
  echo "Tag ${current_tag} is not available locally" >&2
  exit 1
fi

notes_file="$(mktemp -t release-notes.XXXXXX)"
: >"${notes_file}"

cmd=(
  gh release create "${current_tag}"
  --repo "${repo}"
  --title "${title}"
  --notes-file "${notes_file}"
  --verify-tag
)

if [[ -n "${prerelease_flag}" ]]; then
  cmd+=("${prerelease_flag}")
fi

echo "Prepared empty release notes at: ${notes_file}"
printf 'Command to run:\n  '
printf '%q ' "${cmd[@]}"
printf '\n'

if [[ "${dry_run}" == "true" ]]; then
  echo "Dry run mode: command not executed"
  exit 0
fi

echo "Creating GitHub release via gh CLI"
"${cmd[@]}"
echo "GitHub release created successfully"
