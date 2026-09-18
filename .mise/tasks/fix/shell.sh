#!/usr/bin/env bash

set -euo pipefail

source .agents/skills/shell-scripts/log.sh

check=false
if [[ ${1:-} == --check ]]; then
  check=true
  shift
fi
if [[ $# -ne 0 ]]; then
  error "usage: $0 [--check]"
fi

files=$(mktemp)
trap 'rm -f "$files"' EXIT
fd --type f --extension sh --extension bash --extension zsh --print0 . . .mise/tasks .agents/skills .repoconf/hooks >"$files"
for file in ./*; do
  case "$file" in
    *.sh)
      if [ -f "$file" ]; then
        printf '%s\0' "$file" >>"$files"
      fi
      ;;
  esac
done

status=0
while IFS= read -r -d '' file; do
  file=${file#./}
  if [[ $check == false ]]; then
    patch=$(shellcheck --source-path "$HOME" --format diff -- "$file") || {
      shellcheck_status=$?
      [[ $shellcheck_status -eq 1 ]] || exit "$shellcheck_status"
    }
    if [[ -n $patch ]]; then
      git apply --whitespace=nowarn - <<<"$patch"
    fi
  fi
  shellcheck --source-path "$HOME" -- "$file" || status=$?
done <"$files"

exit "$status"
