#!/bin/bash
#
# one-shot-ios scaffolder
#
# Usage:
#   ./bin/scaffold.sh                       # interactive
#   ./bin/scaffold.sh --app-name DemoApp \
#     --bundle-id com.example.demo \
#     --platforms iOS,macOS \
#     --target-dir ../DemoApp
#
# Copies template/ to <target-dir>, substitutes __APP_NAME__, __BUNDLE_ID__,
# __PLATFORMS__ tokens in file contents, renames directories containing
# __APP_NAME__, and (unless --no-git) runs `git init` in the result.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$REPO_ROOT/template"

APP_NAME=""
BUNDLE_ID=""
PLATFORMS_INPUT=""
TARGET_DIR=""
DO_GIT_INIT=1
FORCE=0

die() { echo -e "${RED}✗ $*${RESET}" >&2; exit 1; }
info() { echo -e "${BLUE}$*${RESET}"; }
ok() { echo -e "${GREEN}✓ $*${RESET}"; }
warn() { echo -e "${YELLOW}⚠ $*${RESET}"; }

usage() {
    cat <<EOF
Usage: $(basename "$0") [options]

Options:
  --app-name <name>        App name (PascalCase, letters+digits)
  --bundle-id <id>         Reverse-DNS bundle id (e.g. com.example.demo)
  --platforms <list>       Comma-separated: iOS, macOS, watchOS (default iOS)
  --target-dir <path>      Where to create the new project
  --no-git                 Skip git init in the output
  --force                  Overwrite existing target directory
  -h, --help               Show this help

If any of --app-name / --bundle-id / --platforms / --target-dir is omitted,
the scaffolder falls back to interactive prompts for the missing values.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --app-name) APP_NAME="$2"; shift 2 ;;
        --bundle-id) BUNDLE_ID="$2"; shift 2 ;;
        --platforms) PLATFORMS_INPUT="$2"; shift 2 ;;
        --target-dir) TARGET_DIR="$2"; shift 2 ;;
        --no-git) DO_GIT_INIT=0; shift ;;
        --force) FORCE=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) die "Unknown argument: $1" ;;
    esac
done

validate_app_name() {
    local name="$1"
    [[ "$name" =~ ^[A-Z][A-Za-z0-9]*$ ]] || die "App name must be PascalCase letters+digits (got: '$name')"
}

validate_bundle_id() {
    local id="$1"
    [[ "$id" =~ ^[a-zA-Z][a-zA-Z0-9-]*(\.[a-zA-Z][a-zA-Z0-9-]*)+$ ]] || die "Bundle id must be reverse-DNS (got: '$id')"
}

validate_platforms() {
    local raw="$1"
    [ -n "$raw" ] || die "At least one platform required"
    local IFS=','
    read -ra arr <<< "$raw"
    for p in "${arr[@]}"; do
        p_trimmed="$(echo "$p" | tr -d '[:space:]')"
        case "$p_trimmed" in
            iOS|macOS|watchOS) ;;
            *) die "Unsupported platform '$p_trimmed' (allowed: iOS, macOS, watchOS)" ;;
        esac
    done
}

prompt_if_missing() {
    if [ -z "$APP_NAME" ]; then
        read -r -p "App name (PascalCase, e.g. DemoApp): " APP_NAME
    fi
    validate_app_name "$APP_NAME"

    if [ -z "$BUNDLE_ID" ]; then
        read -r -p "Bundle ID (e.g. com.example.$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')): " BUNDLE_ID
    fi
    validate_bundle_id "$BUNDLE_ID"

    if [ -z "$PLATFORMS_INPUT" ]; then
        read -r -p "Platforms [iOS,macOS,watchOS] (default iOS): " PLATFORMS_INPUT
        PLATFORMS_INPUT="${PLATFORMS_INPUT:-iOS}"
    fi
    validate_platforms "$PLATFORMS_INPUT"

    if [ -z "$TARGET_DIR" ]; then
        local default_dir="../$APP_NAME"
        read -r -p "Target directory (default $default_dir): " TARGET_DIR
        TARGET_DIR="${TARGET_DIR:-$default_dir}"
    fi
}

prompt_if_missing

# Normalize platforms: trimmed, comma-joined
PLATFORMS_NORMALIZED="$(echo "$PLATFORMS_INPUT" | tr -d '[:space:]')"
# ProjectDescription Destination cases. Tuist's Destination enum uses device-
# level cases (.iPhone/.iPad/.mac/.appleWatch), not umbrella .iOS/.macOS names —
# those exist only as static Destinations sets. Expand each user platform to
# the concrete cases that go inside a `destinations: [...]` array literal.
# In parallel, build a matching DeploymentTargets expression: Tuist rejects
# deployment platforms that aren't represented in `destinations`, so both
# substitutions must track the same set of selected platforms.
IOS_DEPLOYMENT="18.0"
MACOS_DEPLOYMENT="15.0"
WATCHOS_DEPLOYMENT="11.0"

PLATFORMS_PD=""
dep_iOS=""; dep_macOS=""; dep_watchOS=""
platform_count=0
IFS=',' read -ra platform_arr <<< "$PLATFORMS_NORMALIZED"
for p in "${platform_arr[@]}"; do
    case "$p" in
        iOS) expanded=".iPhone, .iPad"; dep_iOS=1 ;;
        macOS) expanded=".mac"; dep_macOS=1 ;;
        watchOS) expanded=".appleWatch"; dep_watchOS=1 ;;
        *) die "Unsupported platform '$p' (allowed: iOS, macOS, watchOS)" ;;
    esac
    platform_count=$((platform_count + 1))
    if [ -z "$PLATFORMS_PD" ]; then
        PLATFORMS_PD="$expanded"
    else
        PLATFORMS_PD="$PLATFORMS_PD, $expanded"
    fi
done

# DeploymentTargets: single-platform gets the shorthand (.iOS("18.0")),
# multi-platform gets .multiplatform(...) with only the selected keys.
if [ "$platform_count" = 1 ]; then
    if [ -n "$dep_iOS" ]; then
        DEPLOYMENT_TARGETS_PD=".iOS(\"$IOS_DEPLOYMENT\")"
    elif [ -n "$dep_macOS" ]; then
        DEPLOYMENT_TARGETS_PD=".macOS(\"$MACOS_DEPLOYMENT\")"
    else
        DEPLOYMENT_TARGETS_PD=".watchOS(\"$WATCHOS_DEPLOYMENT\")"
    fi
else
    parts=""
    [ -n "$dep_iOS" ] && parts="iOS: \"$IOS_DEPLOYMENT\""
    if [ -n "$dep_macOS" ]; then
        [ -n "$parts" ] && parts="$parts, "
        parts="${parts}macOS: \"$MACOS_DEPLOYMENT\""
    fi
    if [ -n "$dep_watchOS" ]; then
        [ -n "$parts" ] && parts="$parts, "
        parts="${parts}watchOS: \"$WATCHOS_DEPLOYMENT\""
    fi
    DEPLOYMENT_TARGETS_PD=".multiplatform($parts)"
fi

# Resolve target dir to absolute
if [[ "$TARGET_DIR" = /* ]]; then
    ABS_TARGET="$TARGET_DIR"
else
    ABS_TARGET="$(cd "$(dirname "$TARGET_DIR")" 2>/dev/null && pwd)/$(basename "$TARGET_DIR")" || die "Cannot resolve target parent directory"
fi

echo
info "Scaffolding new iOS project:"
echo "  App name:   $APP_NAME"
echo "  Bundle ID:  $BUNDLE_ID"
echo "  Platforms:  $PLATFORMS_NORMALIZED"
echo "  Target dir: $ABS_TARGET"
echo

if [ -e "$ABS_TARGET" ]; then
    if [ "$FORCE" = 1 ]; then
        warn "Target exists; removing (--force)"
        rm -rf "$ABS_TARGET"
    else
        die "Target directory already exists: $ABS_TARGET (use --force to overwrite)"
    fi
fi

# Confirm when interactive (no --app-name arg was supplied means we prompted)
# Skip confirmation in non-interactive / CI (stdin not a tty)
if [ -t 0 ] && [ -t 1 ]; then
    read -r -p "Proceed? [Y/n] " confirm
    case "${confirm:-Y}" in
        y|Y|yes|YES) ;;
        *) die "Aborted" ;;
    esac
fi

mkdir -p "$(dirname "$ABS_TARGET")"
cp -R "$TEMPLATE_DIR" "$ABS_TARGET"
ok "Copied template → $ABS_TARGET"

# Rename directories containing __APP_NAME__ (deepest first)
# `find ... -depth` lists deepest paths first, so parent renames don't invalidate child paths.
find "$ABS_TARGET" -depth -name '*__APP_NAME__*' | while IFS= read -r path; do
    new_path="$(dirname "$path")/$(basename "$path" | sed "s/__APP_NAME__/$APP_NAME/g")"
    mv "$path" "$new_path"
done
ok "Renamed directories and files containing __APP_NAME__"

# Substitute token contents in all text files.
# BSD sed (macOS) requires an empty `-i ''` argument.
find "$ABS_TARGET" -type f \
    \( -name '*.swift' -o -name '*.md' -o -name '*.plist' -o -name '*.yml' \
       -o -name '*.yaml' -o -name '*.json' -o -name '*.entitlements' \
       -o -name '*.xcplayground' -o -name 'Makefile' -o -name '*.sh' \
       -o -name '.gitignore' -o -name '.tuist-version' -o -name '.xcode-version' \) \
    -print0 | while IFS= read -r -d '' file; do
    sed -i '' \
        -e "s/__APP_NAME__/$APP_NAME/g" \
        -e "s|__BUNDLE_ID__|$BUNDLE_ID|g" \
        -e "s|__PLATFORMS__|$PLATFORMS_PD|g" \
        -e "s|__DEPLOYMENT_TARGETS__|$DEPLOYMENT_TARGETS_PD|g" \
        "$file"
done
ok "Substituted tokens in file contents"

# Make emitted scripts executable
chmod +x "$ABS_TARGET/scripts/setup.sh" 2>/dev/null || true

if [ "$DO_GIT_INIT" = 1 ] && command -v git >/dev/null 2>&1; then
    (cd "$ABS_TARGET" && git init -q && git add -A && git commit -q -m "Initial scaffold from one-shot-ios" 2>/dev/null || true)
    ok "Initialized git repo"
fi

echo
ok "Done!"
echo
echo "Next steps:"
echo "  cd $ABS_TARGET"
echo "  make setup      # verify Xcode + Tuist versions"
echo "  make project    # tuist install + tuist generate"
echo "  make test       # unit + snapshot tests"
