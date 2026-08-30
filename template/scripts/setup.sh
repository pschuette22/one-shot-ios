#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo -e "${BLUE}Setting up __APP_NAME__...${RESET}\n"

if ! command -v brew &> /dev/null; then
    echo -e "${RED}Homebrew is not installed. Install it from https://brew.sh${RESET}"
    exit 1
fi

ensure_xcode() {
    local expected_version
    expected_version=$(cat "$PROJECT_DIR/.xcode-version" | tr -d '[:space:]')

    if ! command -v xcodes &> /dev/null; then
        echo -e "${YELLOW}Installing xcodes CLI...${RESET}"
        brew install xcodes
    fi

    local installed_version
    installed_version=$(xcodebuild -version 2>/dev/null | head -1 | awk '{print $2}')

    local norm_installed norm_expected
    norm_installed=$(echo "$installed_version" | sed 's/\.0$//')
    norm_expected=$(echo "$expected_version" | sed 's/\.0$//')

    if [ "$norm_installed" = "$norm_expected" ]; then
        echo -e "${GREEN}✓ Xcode $expected_version${RESET}"
    else
        echo -e "${YELLOW}⚠ Xcode version mismatch: selected $installed_version, expected $expected_version${RESET}"
        if xcodes installed | grep -q "$expected_version"; then
            echo -e "${YELLOW}  Xcode $expected_version is installed but not selected. Selecting...${RESET}"
            sudo xcodes select "$expected_version"
            echo -e "${GREEN}✓ Xcode $expected_version${RESET}"
        else
            echo -e "${YELLOW}  Xcode $expected_version is not installed.${RESET}"
            echo -e "${YELLOW}  Run: xcodes install $expected_version${RESET}"
            exit 1
        fi
    fi
}

ensure_tuist() {
    local expected_version
    expected_version=$(cat "$PROJECT_DIR/.tuist-version" | tr -d '[:space:]')

    if ! command -v tuist &> /dev/null; then
        echo -e "${YELLOW}Installing tuist@$expected_version...${RESET}"
        brew tap tuist/tuist
        brew install --formula "tuist@$expected_version"
    fi

    local installed_version
    installed_version=$(tuist version 2>/dev/null | tr -d '[:space:]')

    if [ "$installed_version" = "$expected_version" ]; then
        echo -e "${GREEN}✓ tuist $expected_version${RESET}"
    else
        echo -e "${YELLOW}tuist version mismatch: installed $installed_version, expected $expected_version${RESET}"
        echo -e "${YELLOW}  Installing tuist@$expected_version...${RESET}"
        brew tap tuist/tuist
        brew install --formula "tuist@$expected_version"
        installed_version=$(tuist version 2>/dev/null | tr -d '[:space:]')
        if [ "$installed_version" = "$expected_version" ]; then
            echo -e "${GREEN}✓ tuist $expected_version${RESET}"
        else
            echo -e "${RED}✗ Failed to install tuist@$expected_version (got $installed_version)${RESET}"
            exit 1
        fi
    fi
}

# Seeds .env.local from the tracked .env.template, then keeps it in sync as the
# template gains keys. Existing values are never read or rewritten — only keys
# absent from .env.local are appended, so a local secret survives every run.
ensure_env_local() {
    local template="$PROJECT_DIR/.env.template"
    local env_local="$PROJECT_DIR/.env.local"

    if [ ! -f "$template" ]; then
        echo -e "${YELLOW}⚠ No .env.template found; skipping .env.local${RESET}"
        return
    fi

    if [ ! -f "$env_local" ]; then
        cp "$template" "$env_local"
        echo -e "${GREEN}✓ Created .env.local from .env.template${RESET}"
        echo -e "${YELLOW}  Edit .env.local to set your TUIST_DEV_TEAM_ID${RESET}"
        return
    fi

    local added=0 line key
    while IFS= read -r line || [ -n "$line" ]; do
        key=$(printf '%s' "$line" | sed -nE 's/^[[:space:]]*(export[[:space:]]+)?([A-Za-z_][A-Za-z0-9_]*)=.*/\2/p')
        if [ -z "$key" ]; then
            continue
        fi

        if grep -qE "^[[:space:]]*(export[[:space:]]+)?$key=" "$env_local"; then
            continue
        fi

        # Keep the file newline-terminated so the append cannot join two entries.
        if [ -n "$(tail -c1 "$env_local")" ]; then
            printf '\n' >> "$env_local"
        fi
        printf '%s\n' "$line" >> "$env_local"
        echo -e "${YELLOW}  + $key${RESET}"
        added=$((added + 1))
    done < "$template"

    if [ "$added" -gt 0 ]; then
        echo -e "${GREEN}✓ .env.local gained $added key(s) from .env.template — fill them in${RESET}"
    else
        echo -e "${GREEN}✓ .env.local${RESET}"
    fi
}

ensure_xcode
ensure_tuist
ensure_env_local

echo -e "\n${GREEN}Setup complete!${RESET}"
