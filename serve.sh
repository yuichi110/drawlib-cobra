#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

export UV_DEFAULT_INDEX="${UV_DEFAULT_INDEX:-https://pypi.org/simple}"

if [ -z "${DRAWLIB_CMD:-}" ]; then
    if command -v drawlib &> /dev/null; then
        DRAWLIB_CMD="drawlib"
    elif command -v uvx &> /dev/null; then
        DRAWLIB_CMD="uvx --default-index $UV_DEFAULT_INDEX drawlib@0.3.9"
    else
        DRAWLIB_CMD="drawlib"
    fi
fi

# Skip slow pre-flight link check when starting the preview server interactively
# (unless --check is explicitly passed).
EXTRA_ARGS=()
if [[ " $* " != *" --check "* ]]; then
    EXTRA_ARGS+=("--skip-check")
fi

$DRAWLIB_CMD serve docs/ "${EXTRA_ARGS[@]}" "$@"
