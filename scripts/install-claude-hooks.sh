#!/usr/bin/env bash
# Optional Claude Code reinforcement for portas-em-automatico.
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd -P)"
SETTINGS="${HOME}/.claude/settings.json"
SL_CMD="bash ${SKILL_DIR}/hooks/statusline-context.sh"
BLOCK_CMD="python3 ${SKILL_DIR}/hooks/block-broad-scan.py"

command -v jq >/dev/null 2>&1 || { echo "ERROR: jq is required for Claude hook installation." >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "ERROR: python3 is required for Claude hook installation." >&2; exit 1; }
chmod +x "${SKILL_DIR}/hooks/"*.sh "${SKILL_DIR}/hooks/"*.py 2>/dev/null || true

mkdir -p "${HOME}/.claude"
[ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"
cp "$SETTINGS" "${SETTINGS}.bak-portas"
if ! jq -e '.statusLine' "$SETTINGS" >/dev/null 2>&1; then
  tmp="$(mktemp)"; jq --arg cmd "$SL_CMD" '.statusLine = {type:"command", command:$cmd}' "$SETTINGS" > "$tmp"; mv "$tmp" "$SETTINGS"
fi
if ! jq -e --arg c "$BLOCK_CMD" '[(.hooks.PreToolUse // [])[].hooks[]?.command] | index($c)' "$SETTINGS" >/dev/null 2>&1; then
  tmp="$(mktemp)"; jq --arg c "$BLOCK_CMD" '.hooks.PreToolUse = ((.hooks.PreToolUse // []) + [{matcher:"Bash", hooks:[{type:"command", command:$c}]}])' "$SETTINGS" > "$tmp"; mv "$tmp" "$SETTINGS"
fi
python3 "${SKILL_DIR}/tests/test_block_broad_scan.py" >/dev/null && echo "Claude hook self-test: PASS"
