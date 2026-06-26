#!/usr/bin/env bash
# GG post-tool-use hook: appends tool usage to audit log
# Uses jq (a hard install dependency) so it works the same on macOS and Windows (Git Bash).

set -euo pipefail

LOG_FILE="${HOME}/.claude/gg-audit.log"
input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo "unknown")
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
pwd_val=$(pwd)

echo "${timestamp} | ${tool_name} | ${pwd_val}" >> "$LOG_FILE" 2>/dev/null || true

exit 0
