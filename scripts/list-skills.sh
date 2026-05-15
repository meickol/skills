#!/usr/bin/env bash
set -euo pipefail

# Lists all skills in this repo (by SKILL.md path), sorted.
# Useful for tooling and CI checks.

REPO="$(cd "$(dirname "$0")/.." && pwd)"

cd "$REPO"
find . -name SKILL.md -not -path '*/node_modules/*' | sed 's|^\./||' | sort
