#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="portas-em-automatico"; PLATFORM="${SKILL_PLATFORM:-}"; FORCE=0
usage() { echo "Usage: ./install.sh [--platform codex|claude] [--force]"; }
while [ "$#" -gt 0 ]; do case "$1" in --platform) PLATFORM="${2:-}"; shift 2 ;; --force) FORCE=1; shift ;; -h|--help) usage; exit 0 ;; *) echo "Unknown option: $1" >&2; exit 2 ;; esac; done
if [ -z "$PLATFORM" ]; then
  if command -v codex >/dev/null 2>&1 && ! command -v claude >/dev/null 2>&1; then PLATFORM="codex"
  elif command -v claude >/dev/null 2>&1 && ! command -v codex >/dev/null 2>&1; then PLATFORM="claude"
  else echo "Could not select a single runtime. Use --platform codex or --platform claude." >&2; exit 2; fi
fi
case "$PLATFORM" in codex) DEST_ROOT="${CODEX_SKILLS_DIR:-$HOME/.agents/skills}" ;; claude) DEST_ROOT="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}" ;; *) echo "Unsupported platform: $PLATFORM" >&2; exit 2 ;; esac
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd -P)"; DEST_DIR="$DEST_ROOT/$SKILL_NAME"
if [ "$SOURCE_DIR" != "$DEST_DIR" ]; then
  if [ -e "$DEST_DIR" ]; then [ "$FORCE" -eq 1 ] || { echo "Destination exists: $DEST_DIR (use --force to replace it)" >&2; exit 1; }; rm -rf "$DEST_DIR"; fi
  mkdir -p "$DEST_DIR"; (cd "$SOURCE_DIR" && tar --exclude-vcs -cf - .) | (cd "$DEST_DIR" && tar -xf -)
fi
if [ "$PLATFORM" = "claude" ]; then "$DEST_DIR/scripts/install-claude-hooks.sh"; fi
echo "Installed $SKILL_NAME for $PLATFORM at $DEST_DIR"
