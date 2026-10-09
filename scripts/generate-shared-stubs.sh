#!/usr/bin/env bash
# Source of truth for platform-mechanics skill stubs is shared-stubs/.
# Never edit the copies under ai-staff*/skills/; CI fails if they drift.
# Run this script to sync every ai-staff*/ plugin with shared-stubs/.
# It only adds and overwrites: removing a stub from shared-stubs/ does not
# delete its copies, so delete those by hand in the same change.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

shopt -s nullglob

stubs=()
for dir in shared-stubs/*/; do
  name="$(basename "$dir")"
  if [ ! -f "$dir/SKILL.md" ] || [ -L "$dir/SKILL.md" ]; then
    echo "error: $dir has no SKILL.md (regular file); every shared stub needs one" >&2
    exit 1
  fi
  stubs+=("$name")
done

plugins=()
for dir in ai-staff*/; do
  plugin="${dir%/}"
  if [ -f "$plugin/.claude-plugin/plugin.json" ]; then
    plugins+=("$plugin")
  fi
done

if [ "${#stubs[@]}" -eq 0 ]; then
  echo "error: no shared stubs found (expected shared-stubs/<name>/SKILL.md under $root)" >&2
  exit 1
fi
if [ "${#plugins[@]}" -eq 0 ]; then
  echo "error: no plugin directories found (expected ai-staff*/.claude-plugin/plugin.json under $root)" >&2
  exit 1
fi

for plugin in "${plugins[@]}"; do
  for name in "${stubs[@]}"; do
    src="shared-stubs/$name/SKILL.md"
    dest="$plugin/skills/$name/SKILL.md"
    if [ -f "$dest" ] && [ ! -L "$dest" ] && cmp -s "$src" "$dest"; then
      echo "ok $dest"
    else
      mkdir -p "$plugin/skills/$name"
      # Replace a symlink (or stray file) rather than writing through it.
      rm -f "$dest"
      cp "$src" "$dest"
      echo "updated $dest"
    fi
  done
done
