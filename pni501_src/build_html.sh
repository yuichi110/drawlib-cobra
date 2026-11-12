#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PARENT_DIR"

if [ -z "${DRAWLIB_CMD:-}" ]; then
    if command -v drawlib &> /dev/null; then
        DRAWLIB_CMD="drawlib"
    elif command -v uvx &> /dev/null; then
        DRAWLIB_CMD="uvx --default-index ${UV_DEFAULT_INDEX:-https://pypi.org/simple} drawlib@0.3.9"
    else
        DRAWLIB_CMD="drawlib"
    fi
fi

echo "Building PNI501 Diagnostic Report HTML -> docs/pni501/ ..."
$DRAWLIB_CMD build html pni501_src/ -o docs/pni501/ -s pni501_src/styles.py -u pni501_src/utils.py
echo "HTML build complete: docs/pni501/"
