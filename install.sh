#!/usr/bin/env bash
# GG Plugin installer — copies commands, skills, and hooks into ~/.claude

set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
SETTINGS_FILE="${CLAUDE_DIR}/settings.json"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[gg]${NC} $*"; }
warn()    { echo -e "${YELLOW}[gg]${NC} $*"; }
error()   { echo -e "${RED}[gg]${NC} $*"; exit 1; }

check_deps() {
    if ! command -v jq &>/dev/null; then
        error "jq is required. Install it with: brew install jq"
    fi
}

install_commands() {
    local dest="${CLAUDE_DIR}/commands/gg"
    mkdir -p "$dest"
    cp -f "${PLUGIN_ROOT}/commands/"*.md "$dest/"
    info "Commands installed → ${dest}/"
    for f in "${PLUGIN_ROOT}/commands/"*.md; do
        name=$(basename "$f" .md)
        echo "    /gg:${name}"
    done
}

install_skills() {
    local src="${PLUGIN_ROOT}/skills"
    if [ ! -d "$src" ] || ! ls -d "$src"/*/ &>/dev/null; then
        warn "No skills to install yet (skills/ is empty or missing) — skipping."
        return 0
    fi

    local dest="${CLAUDE_DIR}/skills"
    mkdir -p "$dest"
    for skill_dir in "$src"/*/; do
        skill_name=$(basename "$skill_dir")
        mkdir -p "${dest}/${skill_name}"
        cp -f "${skill_dir}SKILL.md" "${dest}/${skill_name}/SKILL.md"
        echo "    ${skill_name}"
    done
    info "Skills installed → ${dest}/"
}

install_hooks() {
    if [ ! -f "$SETTINGS_FILE" ]; then
        echo '{}' > "$SETTINGS_FILE"
    fi

    # Back up settings before merging
    cp "$SETTINGS_FILE" "${SETTINGS_FILE}.bak"
    warn "Settings backed up → ${SETTINGS_FILE}.bak"

    local hooks_json="${PLUGIN_ROOT}/hooks/hooks.json"

    # Substitute plugin root path into hooks
    local resolved_hooks
    resolved_hooks=$(sed "s|\\\$GG_PLUGIN_ROOT|${PLUGIN_ROOT}|g" "$hooks_json")

    # Merge PreToolUse hooks
    local pre_hook
    pre_hook=$(echo "$resolved_hooks" | jq '.hooks.PreToolUse[0]')

    local post_hook
    post_hook=$(echo "$resolved_hooks" | jq '.hooks.PostToolUse[0]')

    # Merge into settings.json non-destructively
    jq --argjson pre "$pre_hook" --argjson post "$post_hook" '
        .hooks.PreToolUse  = ((.hooks.PreToolUse  // []) + [$pre]  | unique_by(.matcher)) |
        .hooks.PostToolUse = ((.hooks.PostToolUse // []) + [$post] | unique_by(.matcher))
    ' "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp" && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"

    info "Hooks merged → ${SETTINGS_FILE}"
}

make_hooks_executable() {
    chmod +x "${PLUGIN_ROOT}/hooks/pre-tool-use.sh"
    chmod +x "${PLUGIN_ROOT}/hooks/post-tool-use.sh"
}

main() {
    echo ""
    echo "  Installing plugin-grupo-gestao..."
    echo ""

    check_deps
    make_hooks_executable
    install_commands
    install_skills
    install_hooks

    echo ""
    info "Installation complete."
    echo ""
    echo "  Restart Claude Code and use /gg:<command> to get started."
    echo "  See README.md for the full command reference."
    echo ""
}

main "$@"
