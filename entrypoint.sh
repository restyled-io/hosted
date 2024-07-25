#!/usr/bin/env bash
set -euo pipefail

repo=
number=
job_url=

while [[ -n "$1" ]]; do
  case "$1" in
    "--job-url")
      shift
      job_url=$1
      ;;
    *)
      if [[ "$1" =~ ([^/]+)/([^/]+)#([0-9]+) ]]; then
        repo=${BASH_REMATCH[1]}/${BASH_REMATCH[2]}
        number=${BASH_REMATCH[3]}
        break
      fi
      ;;
  esac

  shift
done

if [[ -z "$repo" ]] || [[ -z "$number" ]]; then
  echo "Unable to parse OWNER/REPO#NUMBER argument: $*" >&2
  exit 64
fi

cwd=$(mktemp -d "/tmp/restyler-XXXXXX")
event=$(mktemp)

export GH_TOKEN="$GITHUB_ACCESS_TOKEN"

{
  echo '{"pull_request":'
  gh api "repos/$repo/pulls/$number"
  echo '}'
} >"$event"

cd "$cwd"

act \
  --bind \
  --env GITHUB_REPOSITORY="$repo" \
  --env HOST_DIRECTORY="$cwd" \
  --env JOB_URL="$job_url" \
  --env LOG_FORMAT="${LOG_FORMAT:-json}" \
  --env LOG_LEVEL="${LOG_LEVEL:-info}" \
  --eventpath "$event" \
  --platform ubuntu-latest=restyled/act:latest \
  --secret GITHUB_TOKEN="$GITHUB_ACCESS_TOKEN" \
  --workflows /opt/workflows
