#!/usr/bin/env bash
# GG pre-tool-use hook: warns before destructive Bash commands
# Uses jq (a hard install dependency) so it works the same on macOS and Windows (Git Bash).

set -euo pipefail

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name // ""' 2>/dev/null || echo "")

if [ "$tool_name" != "Bash" ]; then
    exit 0
fi

command=$(echo "$input" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")

# Patterns that warrant a warning
DESTRUCTIVE_PATTERNS=(
    "rm -rf"
    "rm -r"
    "DROP TABLE"
    "DROP DATABASE"
    "git reset --hard"
    "git push --force"
    "git push -f"
    "truncate"
    "DELETE FROM"
    "format"
)

for pattern in "${DESTRUCTIVE_PATTERNS[@]}"; do
    if echo "$command" | grep -qi "$pattern"; then
        jq -n --arg p "$pattern" \
            '{systemMessage: ("[GG Hook] Destructive command detected: \"" + $p + "\". Proceeding — make sure this is intentional.")}'
        exit 0
    fi
done

exit 0
